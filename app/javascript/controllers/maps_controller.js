import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import { MAP_STYLE, DEFAULT_ZOOM, LAYER_COLORS } from '../maps/config.js'
import { loadLayer, removeSourceLayers } from '../maps/layers/index.js'
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
      // Polygon Anchor
      this.map.addLayer({
        id: 'polygon-anchor',
        type: 'background',
        layout: { visibility: 'none' }
      });

      // HIGHLIGHT SOURCES
      this.map.addSource('feature-highlight', {
        type: 'geojson',
        data: { type: 'FeatureCollection', features: [] }
      });

      // POLYGON HIGHLIGHT (Only for Lines/Polygons)
      this.map.addLayer({
        id: 'feature-highlight',
        type: 'line',
        source: 'feature-highlight',
        filter: ['any', ['==', ['geometry-type'], 'Polygon'], ['==', ['geometry-type'], 'LineString']],
        paint: {
          'line-color': ['coalesce', ['get', 'stroke'], '#FF00FF'],
          'line-width': 4,
          'line-opacity': 0.8
        }
      });

      // POINT HIGHLIGHT (The Halo)
      this.map.addLayer({
        id: 'point-highlight',
        type: 'circle',
        source: 'feature-highlight',
        filter: ['==', ['geometry-type'], 'Point'], // ONLY show for points
        paint: {
          'circle-radius': 12,
          'circle-color': 'rgba(255, 255, 255, 0)',
          'circle-stroke-width': 3,
          'circle-stroke-color': ['coalesce', ['get', 'stroke'], '#FF00FF'],
          'circle-stroke-opacity': 0.8
        }
      });

      // Sync UI for existing layers 
      this._syncActiveStates();

      if (this.hasMarkersValue && this.markersValue.length > 0) {
        const [lng, lat] = this.markersValue[0]
        // Pass the default title value as extraData
        this._updateMarker(Number(lng), Number(lat), { title: this.markerTooltipTitleValue })
      }

      if (this.hasDefaultLayerIdValue) {
        const checkbox = document.getElementById(this.defaultLayerIdValue)
        if (checkbox) {
          checkbox.checked = true
          checkbox.dispatchEvent(new Event('change', { bubbles: true }))
        }
      }
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

  async toggleLayer(event) {
    const el = event.currentTarget;
    const targetId = el.dataset.checkboxId || el.id;
    const isCheckbox = el.type === 'checkbox';

    if (!targetId) return;

    // SYNC: Button -> Checkbox
    if (!isCheckbox) {
      const sidebarCheckbox = document.getElementById(targetId);
      if (sidebarCheckbox) {
        sidebarCheckbox.checked = !sidebarCheckbox.checked;
        sidebarCheckbox.dispatchEvent(new Event('change', { bubbles: true }));
        return;
      }
    }

    // VISUAL SYNC: Highlight buttons across tabs
    this._updateVisualState(targetId, el.checked);

    const url = el.dataset.url;
    const color = LAYER_COLORS[targetId];

    if (el.checked) {
      await this._loadAndAttachLayer(url, color, el.dataset.fit !== 'false');
    } else {
      const sourceId = this._sourceIdFromUrl(url);
      this._forget(sourceId);
      removeSourceLayers(this.map, sourceId);
      // // Clear highlight if layer is removed
      // this._clearHighlight();
    }
  }

  _updateVisualState(id, isActive) {
    const buttons = document.querySelectorAll(`[data-checkbox-id="${id}"]`);
    buttons.forEach(btn => btn.classList.toggle('active', isActive));

    const checkbox = document.getElementById(id);
    if (checkbox) checkbox.checked = isActive;
  }

  _syncActiveStates() {
    Object.keys(LAYER_COLORS).forEach(id => {
      // Check if any layer starting with this ID is currently in the map
      const isLoaded = this.layerIds.some(lId => lId.includes(id));
      if (isLoaded) this._updateVisualState(id, true);
    });
  }

  // _clearHighlight() {
  //   const source = this.map.getSource('feature-highlight');
  //   if (source) source.setData({ type: 'FeatureCollection', features: [] });
  // }

  async _loadAndAttachLayer(url, color, fit = true) {
    const outlineColor = color ? this._computeOutlineColor(color) : undefined
    const { fc, sourceId, layerIds } = await loadLayer(this.map, url, { color, outlineColor })

    this._remember(sourceId, layerIds)

    // Attach popup logic to the newly loaded layers (reads GeoJSON properties automatically)
    layerIds.forEach(id => attachPopup(this.map, id))

    if (fit && fc.features.length > 0) {
      const b = boundsFrom(fc)
      if (!b.isEmpty()) this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 800 })
    }
  }

  _sourceIdFromUrl(url) {
    return new URL(url, window.location.origin).pathname.replace(/[^\w-]/g, ':')
  }

  _remember(sourceId, layerIds) {
    if (!this.sourceIds.includes(sourceId)) this.sourceIds.push(sourceId)
    const set = this.layersBySource.get(sourceId) || new Set()
    layerIds.forEach((id) => {
      if (!this.layerIds.includes(id)) this.layerIds.push(id)
      set.add(id)
    })
    this.layersBySource.set(sourceId, set)
  }

  _forget(sourceId) {
    const set = this.layersBySource.get(sourceId)
    if (set) {
      for (const id of set) {
        this.layerIds = this.layerIds.filter((x) => x !== id)
      }
      this.layersBySource.delete(sourceId)
    }
    this.sourceIds = this.sourceIds.filter((x) => x !== sourceId)
  }

  _updateMarker(lng, lat) {
    this._domMarker = upsertDomMarker(this._domMarker, this.map, {
      lng: Number(lng),
      lat: Number(lat)
    });
  }

  _computeOutlineColor(color) {
    let hex = color.replace('#', '')
    if (hex.length === 3) hex = hex.split('').map(c => c + c).join('')
    let r = parseInt(hex.substring(0, 2), 16), g = parseInt(hex.substring(2, 4), 16), b = parseInt(hex.substring(4, 6), 16)
    r = Math.floor(r * 0.75); g = Math.floor(g * 0.75); b = Math.floor(b * 0.75)
    return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`
  }
}