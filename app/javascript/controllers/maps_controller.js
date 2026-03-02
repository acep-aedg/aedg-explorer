import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import { MAP_STYLE, DEFAULT_ZOOM, LAYER_COLORS } from '../maps/config.js'
import { loadLayer, removeSourceLayers } from '../maps/layers/index.js'
import { boundsFrom } from '../maps/geo.js'
import { upsertDomMarker } from '../maps/dom_marker.js'
import { defaultPopupTemplate } from '../maps/popup.js'
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
      // Initial Marker setup
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

  focusSection(event) {
    const { lng, lat } = event.params;

    this._updateMarker(lng, lat);

    this.map.flyTo({
      center: [Number(lng), Number(lat)],
      zoom: 10
    });
  }

  async toggleLayer(event) {
    const el = event.currentTarget
    const url = el.dataset.url || el.dataset.layerUrl || el.dataset.mapLayerUrl
    if (!url) return
    const color = el.dataset.color || LAYER_COLORS[el.id]

    if (el.checked) {
      await this._loadAndAttachLayer(url, color, el.dataset.fit !== 'false')
    } else {
      const sourceId = this._sourceIdFromUrl(url)
      this._forget(sourceId)
      removeSourceLayers(this.map, sourceId)
    }
  }

  async showLayer(event) {
    const el = event.currentTarget
    const url = el.dataset.url || el.dataset.layerUrl || el.dataset.mapLayerUrl
    if (!url) return
    const color = el.dataset.color || LAYER_COLORS[el.dataset.checkboxId]
    await this._ensureMapReady()
    await this._loadAndAttachLayer(url, color, el.dataset.fit !== 'false')
    const cb = this._findCheckboxForUrl(url, el.dataset.checkboxId)
    if (cb && !cb.checked) cb.checked = true
  }

  // --- PRIVATE HELPERS ---

  _updateMarker(lng, lat) {
    this._domMarker = upsertDomMarker(this._domMarker, this.map, {
      lng: Number(lng),
      lat: Number(lat)
    });
  }

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

  async _ensureMapReady() {
    if (!this.map) throw new Error('Map not initialized')
    if (!this.map.isStyleLoaded()) await new Promise((r) => this.map.once('load', r))
  }

  _findCheckboxForUrl(url, checkboxId) {
    if (checkboxId) return document.getElementById(checkboxId)
    const sel = `input.form-check-input[data-url="${this._cssEscape(url)}"]`
    return this.element.querySelector(sel) || document.querySelector(sel)
  }

  _cssEscape(s = '') { return String(s).replace(/["\\]/g, '\\$&') }

  _sourceIdFromUrl(url) {
    return new URL(url, window.location.origin).pathname.replace(/[^\w-]/g, ':')
  }

  _remember(sourceId, layerIds) {
    if (!this.sourceIds.includes(sourceId)) this.sourceIds.push(sourceId)
    for (const id of layerIds) if (!this.layerIds.includes(id)) this.layerIds.push(id)
    const set = this.layersBySource.get(sourceId) || new Set()
    layerIds.forEach((id) => set.add(id))
    this.layersBySource.set(sourceId, set)
  }

  _forget(sourceId) {
    const set = this.layersBySource.get(sourceId)
    if (set) {
      for (const id of set) this.layerIds = this.layerIds.filter((x) => x !== id)
      this.layersBySource.delete(sourceId)
    }
    this.sourceIds = this.sourceIds.filter((x) => x !== sourceId)
  }

  _computeOutlineColor(color) {
    let hex = color.replace('#', '')
    if (hex.length === 3) hex = hex.split('').map(c => c + c).join('')
    let r = parseInt(hex.substring(0, 2), 16), g = parseInt(hex.substring(2, 4), 16), b = parseInt(hex.substring(4, 6), 16)
    const factor = 0.75
    r = Math.floor(r * factor); g = Math.floor(g * factor); b = Math.floor(b * factor)
    const toHex = (v) => v.toString(16).padStart(2, '0')
    return `#${toHex(r)}${toHex(g)}${toHex(b)}`
  }
}