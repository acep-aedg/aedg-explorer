import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import { MAP_STYLE, DEFAULT_ZOOM, LAYER_COLORS } from '../maps/config.js'
import { loadLayer } from '../maps/layers/index.js'
import { boundsFrom } from '../maps/geo.js'
import { upsertDomMarker } from '../maps/dom_marker.js'
import { attachPopup } from '../maps/popup.js'

/**
 * MapsController
 * * Manages a Mapbox GL instance with support for:
 * - Lazy-loading GeoJSON layers (On-demand fetching to prevent initial lag)
 * - Visual synchronization between map layers, checkboxes, and UI buttons
 * - The Checkbox is the Source of Truth (DOM-based State)
 * - Feature highlighting and automatic map fitting (zooming)
 */
export default class extends Controller {
  static targets = ['map', 'loading', 'swatch']
  static values = {
    token: String,
    mapCenter: { type: Array, default: [-154.49, 63.58] },
    defaultLayerId: String,
    markers: Array,
    markerTooltipTitle: { type: String, default: '' },
  }

  connect() {
    mapboxgl.accessToken = this.tokenValue
    
    // State Tracking
    this.layerIds = []                  // Flat list of all Mapbox layer IDs
    this.sourceIds = []                 // Flat list of all Mapbox source IDs
    this.layersBySource = new Map()     // Maps sourceId -> Set of layerIds
    this.layersByCheckbox = new Map()   // Maps layerKey (layer_id) -> Array of Mapbox layerIds
    this.featureCollections = new Map() // Cached GeoJSON data for bounds calculations
    this._domMarker = null

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: MAP_STYLE,
      center: this.mapCenterValue,
      zoom: DEFAULT_ZOOM,
    })

    this.initSwatches()

    // Expose map instance to the DOM for console debugging if needed
    this.mapTarget._mapbox = this.map

    this.map.on('load', () => {
      this._setupAnchorsAndHighlights()
      
      // LAZY LOADING STRATEGY: 
      // Instead of pre-loading 10+ GeoJSONs on refresh (which causes 3s+ lag),
      // we only load markers and the 'defaultLayerId' immediately.
      this._handleInitialState()
    })
  }

  // --- PUBLIC ACTIONS ---

  /**
   * Colors the small color-indicators next to checkboxes based on config.js
   */
  initSwatches() {
    this.swatchTargets.forEach((swatch) => {
      const checkbox = swatch.closest('.form-check').querySelector('input')
      const color = LAYER_COLORS[checkbox.id]
      if (color) swatch.style.backgroundColor = color
    })
  }

  /**
   * Main entry point for user interaction. Handles clicks from:
   * 1. Actual checkboxes (isCheckbox = true)
   * 2. UI Buttons with [data-layer-id] (isCheckbox = false)
   */
  toggleLayer(event) {
    const el = event.currentTarget
    const layer_id = el.dataset.layerId || el.id
    const isCheckbox = el.type === 'checkbox'
    const url = el.dataset.url

    if (!layer_id) return

    // If a non-checkbox (like a button) was clicked, find its "source of truth" 
    // checkbox and trigger it. This keeps the logic centralized in the checkbox state.
    if (!isCheckbox) {
      const sidebarCheckbox = document.getElementById(layer_id)
      if (sidebarCheckbox) {
        sidebarCheckbox.checked = !sidebarCheckbox.checked
        sidebarCheckbox.dispatchEvent(new Event('change', { bubbles: true }))
        return
      }
    }

    // CASE 1: Layer already exists in Mapbox memory. Just toggle visibility.
    if (this.layersByCheckbox.has(layer_id)) {
      const visibility = el.checked ? 'visible' : 'none'
      const layerIds = this.layersByCheckbox.get(layer_id)

      layerIds.forEach(id => {
        this.map.setLayoutProperty(id, 'visibility', visibility)
      })

      this._updateVisualState(layer_id, el.checked)

      if (el.checked && el.dataset.fit !== 'false') {
        this._fitToLayer(layer_id)
      }
    } 
    // CASE 2: Layer hasn't been fetched yet. Fetch, add to map, then show.
    else if (el.checked && url) {
      this._loadLayerOnDemand(layer_id, url, el)
    }
  }

  // --- PRIVATE ---

  /**
   * Performs the async fetch and Mapbox layer injection.
   * Disables the UI element during the load to prevent race conditions.
   */
  _loadLayerOnDemand(layer_id, url, checkbox) {
    if (this.hasLoadingTarget) this.loadingTarget.classList.remove('d-none')
    checkbox.disabled = true 

    const color = LAYER_COLORS[layer_id]
    const outlineColor = color ? this._computeOutlineColor(color) : undefined

    loadLayer(this.map, url, { 
      color, 
      outlineColor,
      visibility: 'visible' 
    })
    /**
     * Note: 'fc' stands for FeatureCollection.(contains an array of coordinate 
     * pairs that define every single "vertex" (corner) of that shape.)
     * While Mapbox handles the visual rendering, we store the 'fc' in our own 
     * Map (this.featureCollections) so we can access the raw coordinates for 
     * bounds calculations (zooming) without having to query the Mapbox API.
     */
    .then(({ fc, sourceId, layerIds }) => {
      // Map the internal Mapbox IDs to our UI ID for future toggling
      this._remember(sourceId, layerIds, layer_id)
      this.featureCollections.set(layer_id, fc)
      
      // Register these specific layers for the popup click handler
      layerIds.forEach(lId => attachPopup(this.map, lId))

      this._updateVisualState(layer_id, true)
      
      // Automatically zoom to the new data if requested
      if (checkbox.dataset.fit !== 'false') {
        this._fitToLayer(layer_id)
      }
    })
    .catch(e => console.error(`[Mapbox] Error loading layer: ${layer_id}`, e))
    .finally(() => {
      checkbox.disabled = false
      if (this.hasLoadingTarget) this.loadingTarget.classList.add('d-none')
    })
  }

  /**
   * Zooms the map to fit the bounding box of the GeoJSON data
   */
  _fitToLayer(layer_id) {
    const fc = this.featureCollections.get(layer_id)
    if (fc && fc.features.length > 0) {
      const b = boundsFrom(fc)
      if (!b.isEmpty()) {
        this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 800 })
      }
    }
  }

  /**
   * Sets up invisible anchor layers (for Z-index ordering) and highlight styles
   */
  _setupAnchorsAndHighlights() {
    // Polygons will be inserted BEFORE this layer to stay under points/labels
    this.map.addLayer({ id: 'polygon-anchor', type: 'background', layout: { visibility: 'none' } })

    this.map.addSource('feature-highlight', {
      type: 'geojson',
      data: { type: 'FeatureCollection', features: [] }
    })

    // Highlight for selected Lines/Polygons
    this.map.addLayer({
      id: 'feature-highlight',
      type: 'line',
      source: 'feature-highlight',
      filter: ['any', ['==', ['geometry-type'], 'Polygon'], ['==', ['geometry-type'], 'LineString']],
      paint: { 'line-color': ['coalesce', ['get', 'stroke'], '#FF00FF'], 'line-width': 4, 'line-opacity': 0.8 }
    })

    // Halo highlight for selected Points
    this.map.addLayer({
      id: 'point-highlight',
      type: 'circle',
      source: 'feature-highlight',
      filter: ['==', ['geometry-type'], 'Point'],
      paint: {
        'circle-radius': 12,
        'circle-color': 'rgba(255, 255, 255, 0)',
        'circle-stroke-width': 3,
        'circle-stroke-color': ['coalesce', ['get', 'stroke'], '#FF00FF'],
        'circle-stroke-opacity': 0.8
      }
    })
  }

  /**
   * Handles markers and the default layer provided by Stimulus Values
   */
  _handleInitialState() {
    if (this.hasMarkersValue && this.markersValue.length > 0) {
      const [lng, lat] = this.markersValue[0]
      this._updateMarker(Number(lng), Number(lat), { title: this.markerTooltipTitleValue })
    }

    if (this.hasDefaultLayerIdValue) {
      const checkbox = document.getElementById(this.defaultLayerIdValue)
      if (checkbox) {
        checkbox.checked = true
        // Manually trigger toggle to kick off lazy loading
        this.toggleLayer({ currentTarget: checkbox })
      }
    }
  }

  /**
   * Synchronizes UI state.
   * If 'id' is active, it finds the checkbox AND any button with [data-layer-id] 
   * and applies the 'active' class/checked state.
   */
  _updateVisualState(id, isActive) {
    // queries all layers realted to btns on the right side of the page
    document.querySelectorAll(`[data-layer-id="${id}"]`).forEach(btn => btn.classList.toggle('active', isActive))
    const checkbox = document.getElementById(id)
    if (checkbox) checkbox.checked = isActive
  }

  _syncActiveStates() {
    Object.keys(LAYER_COLORS).forEach(id => {
      const layerIds = this.layersByCheckbox.get(id)
      if (layerIds && layerIds.some(lId => this.map.getLayer(lId) && this.map.getLayoutProperty(lId, 'visibility') === 'visible')) {
        this._updateVisualState(id, true)
      }
    })
  }

  _remember(sourceId, layerIds, layer_id) {
    if (!this.sourceIds.includes(sourceId)) this.sourceIds.push(sourceId)
    this.layersByCheckbox.set(layer_id, layerIds)
    
    const set = this.layersBySource.get(sourceId) || new Set()
    layerIds.forEach((id) => {
      if (!this.layerIds.includes(id)) this.layerIds.push(id)
      set.add(id)
    })
    this.layersBySource.set(sourceId, set)
  }

  /**
   * Manages the "You are here" marker on the map
   */
  _updateMarker(lng, lat) {
    this._domMarker = upsertDomMarker(this._domMarker, this.map, { lng: Number(lng), lat: Number(lat) })
  }

  /**
   * Generates a darker outline color based on the fill color for better contrast
   */
  _computeOutlineColor(color) {
    let hex = color.replace('#', '')
    if (hex.length === 3) hex = hex.split('').map(c => c + c).join('')
    let r = parseInt(hex.substring(0, 2), 16), g = parseInt(hex.substring(2, 4), 16), b = parseInt(hex.substring(4, 6), 16)
    r = Math.floor(r * 0.75); g = Math.floor(g * 0.75); b = Math.floor(b * 0.75)
    return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`
  }
}