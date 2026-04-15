import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import { MAP_STYLE, DEFAULT_ZOOM, LAYER_COLORS } from '../maps/config.js'
import { loadLayer } from '../maps/layers/index.js'
import { boundsFrom } from '../maps/geo.js'
import { upsertDomMarker } from '../maps/dom_marker.js'
import { attachPopup } from '../maps/popup.js'

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
    this.layerIds = []
    this.sourceIds = []
    this.layersBySource = new Map()
    this.layersByCheckbox = new Map()
    this.featureCollections = new Map()
    this._domMarker = null

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: MAP_STYLE,
      center: this.mapCenterValue,
      zoom: DEFAULT_ZOOM,
    })

    this.initSwatches()
    this.mapTarget._mapbox = this.map

    this.map.on('load', () => {
      this._setupAnchorsAndHighlights()
      
      // LAZY LOADING: We only handle the markers and the default starting layer.
      this._handleInitialState()
    })
  }

  // --- PUBLIC ACTIONS ---

  initSwatches() {
    this.swatchTargets.forEach((swatch) => {
      const checkbox = swatch.closest('.form-check').querySelector('input')
      const color = LAYER_COLORS[checkbox.id]
      if (color) swatch.style.backgroundColor = color
    })
  }

  toggleLayer(event) {
    const el = event.currentTarget
    const targetId = el.dataset.checkboxId || el.id
    const isCheckbox = el.type === 'checkbox'
    const url = el.dataset.url

    if (!targetId) return

    // Ensure we are working with the actual checkbox element
    if (!isCheckbox) {
      const sidebarCheckbox = document.getElementById(targetId)
      if (sidebarCheckbox) {
        sidebarCheckbox.checked = !sidebarCheckbox.checked
        sidebarCheckbox.dispatchEvent(new Event('change', { bubbles: true }))
        return
      }
    }

    // If the layer is already loaded, just toggle visibility
    if (this.layersByCheckbox.has(targetId)) {
      const visibility = el.checked ? 'visible' : 'none'
      const layerIds = this.layersByCheckbox.get(targetId)

      layerIds.forEach(id => {
        this.map.setLayoutProperty(id, 'visibility', visibility)
      })

      this._updateVisualState(targetId, el.checked)

      if (el.checked && el.dataset.fit !== 'false') {
        this._fitToLayer(targetId)
      }
    } 
    // If it's NOT loaded and the user checked it, load it on-demand
    else if (el.checked && url) {
      this._loadLayerOnDemand(targetId, url, el)
    }
  }

  // --- PRIVATE ---

  /**
   * Fetches and adds a layer only when needed.
   */
  _loadLayerOnDemand(id, url, checkbox) {
    if (this.hasLoadingTarget) this.loadingTarget.classList.remove('d-none')
    checkbox.disabled = true // Prevent double-clicks while loading

    const color = LAYER_COLORS[id]
    const outlineColor = color ? this._computeOutlineColor(color) : undefined

    loadLayer(this.map, url, { 
      color, 
      outlineColor,
      visibility: 'visible' 
    })
    .then(({ fc, sourceId, layerIds }) => {
      this._remember(sourceId, layerIds, id)
      this.featureCollections.set(id, fc)
      
      layerIds.forEach(lId => attachPopup(this.map, lId))

      this._updateVisualState(id, true)
      if (checkbox.dataset.fit !== 'false') {
        this._fitToLayer(id)
      }
    })
    .catch(e => console.error(`Failed to load layer on demand: ${id}`, e))
    .finally(() => {
      checkbox.disabled = false
      if (this.hasLoadingTarget) this.loadingTarget.classList.add('d-none')
    })
  }

  _fitToLayer(id) {
    const fc = this.featureCollections.get(id)
    if (fc && fc.features.length > 0) {
      const b = boundsFrom(fc)
      if (!b.isEmpty()) {
        this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 800 })
      }
    }
  }

  _setupAnchorsAndHighlights() {
    this.map.addLayer({ id: 'polygon-anchor', type: 'background', layout: { visibility: 'none' } })

    this.map.addSource('feature-highlight', {
      type: 'geojson',
      data: { type: 'FeatureCollection', features: [] }
    })

    this.map.addLayer({
      id: 'feature-highlight',
      type: 'line',
      source: 'feature-highlight',
      filter: ['any', ['==', ['geometry-type'], 'Polygon'], ['==', ['geometry-type'], 'LineString']],
      paint: { 'line-color': ['coalesce', ['get', 'stroke'], '#FF00FF'], 'line-width': 4, 'line-opacity': 0.8 }
    })

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

  _handleInitialState() {
    // Process markers immediately
    if (this.hasMarkersValue && this.markersValue.length > 0) {
      const [lng, lat] = this.markersValue[0]
      this._updateMarker(Number(lng), Number(lat), { title: this.markerTooltipTitleValue })
    }

    // Load the default layer if one is specified
    if (this.hasDefaultLayerIdValue) {
      const checkbox = document.getElementById(this.defaultLayerIdValue)
      if (checkbox) {
        checkbox.checked = true
        // This will trigger _loadLayerOnDemand because the layer isn't in 'layersByCheckbox' yet
        this.toggleLayer({ currentTarget: checkbox })
      }
    }
  }

  _updateVisualState(id, isActive) {
    document.querySelectorAll(`[data-checkbox-id="${id}"]`).forEach(btn => btn.classList.toggle('active', isActive))
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

  _remember(sourceId, layerIds, checkboxId) {
    if (!this.sourceIds.includes(sourceId)) this.sourceIds.push(sourceId)
    this.layersByCheckbox.set(checkboxId, layerIds)
    
    const set = this.layersBySource.get(sourceId) || new Set()
    layerIds.forEach((id) => {
      if (!this.layerIds.includes(id)) this.layerIds.push(id)
      set.add(id)
    })
    this.layersBySource.set(sourceId, set)
  }

  _updateMarker(lng, lat) {
    this._domMarker = upsertDomMarker(this._domMarker, this.map, { lng: Number(lng), lat: Number(lat) })
  }

  _computeOutlineColor(color) {
    let hex = color.replace('#', '')
    if (hex.length === 3) hex = hex.split('').map(c => c + c).join('')
    let r = parseInt(hex.substring(0, 2), 16), g = parseInt(hex.substring(2, 4), 16), b = parseInt(hex.substring(4, 6), 16)
    r = Math.floor(r * 0.75); g = Math.floor(g * 0.75); b = Math.floor(b * 0.75)
    return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`
  }
}