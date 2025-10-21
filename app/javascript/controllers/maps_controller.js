import { Controller } from '@hotwired/stimulus'
import mapboxgl from 'mapbox-gl'
import { MAP_STYLE, DEFAULT_ZOOM } from '../maps/config.js'
import { loadLayer, loadMarkerLayer, removeSourceLayers } from '../maps/layers/index.js'
import { boundsFrom, featureCollectionFromLngLats } from '../maps/geo.js'
import { upsertDomMarker } from '../maps/dom_marker.js'

export default class extends Controller {
  static targets = ['map', 'loading']
  static values = {
    token: String,
    mapCenter: { type: Array, default: [-154.49, 63.58] },
    defaultLayerUrl: String,
    markers: Array,                   // [[lng,lat], ...] initial coords from view
    markerTooltipTitle: { type: String, default: 'Location' },
  }

  connect() {
    mapboxgl.accessToken = this.tokenValue
    this.layerIds = []
    this.sourceIds = []
    this.layersBySource = new Map()
    this._domMarker = null            // persistent DOM marker (not a Mapbox layer)

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: MAP_STYLE,
      center: this.mapCenterValue,
      zoom: DEFAULT_ZOOM,
    })
    // expose for global cleanup (turbo:before-render / before-cache)
    this.mapTarget._mapbox = this.map

    this.map.on('load', async () => {
      // place static DOM marker from server-provided coords (no hard-coding)
      
      if (this.hasMarkersValue) {
        const [lng0, lat0] = (this.hasMarkersValue && this.markersValue[0])
        const L0 = Number(lng0), A0 = Number(lat0);
        this._domMarker = upsertDomMarker(this._domMarker, this.map, {
          lng: L0, lat: A0, title: this.markerTooltipTitleValue
        })
      }

      // optional default GeoJSON layer
      if (this.hasDefaultLayerUrlValue) {
        const { fc, sourceId, layerIds } =
          await loadLayer(this.map, this.defaultLayerUrlValue, {})
        this._remember(sourceId, layerIds)
        const b = boundsFrom(fc)
        if (!b.isEmpty()) this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 0 })
      }
    })
  }

  // ---- PUBLIC ACTIONS ----

 // Move the persistent DOM marker to a section’s coords and center the map
  focusSection(event) {
    const { lng, lat, title } = event.params
    const L = Number(lng), A = Number(lat)

    this._domMarker = upsertDomMarker(this._domMarker, this.map, {
      lng: L, lat: A, title: title || this.markerTooltipTitleValue
    })
    this.map.flyTo({ center: [L, A], essential: true })
  }

  // Checkbox: add/remove a *layer-based* marker set (simple circles) from markersValue
  async toggleMarker(event) {
    const el = event.currentTarget
    const sourceId = this._markerSourceId()

    if (el.checked) {
      const fc = this._markerFC() // convert [[lng,lat],...] -> FeatureCollection
      const { layerIds } =
        await loadMarkerLayer(this.map, sourceId, fc, { iconSize: 1.2 })
      this._remember(sourceId, layerIds)

      // optional fit when enabling
      const fit = el.dataset.fit ? el.dataset.fit !== 'false' : true
      if (fit) {
        const b = boundsFrom(fc)
        if (!b.isEmpty()) this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 0 })
      }
    } else {
      // remove the marker layer+source and forget ids
      this._forget(sourceId)
      removeSourceLayers(this.map, sourceId)
    }
  }

  // Checkbox: add/remove generic GeoJSON layers (districts, service areas, etc.)
  async toggleLayer(event) {
    const el = event.currentTarget
    const url = el.dataset.url || el.dataset.layerUrl || el.dataset.mapLayerUrl
    if (!url) return

    if (el.checked) {
      // load the layer (polygon or point) with optional colors
      const { fc, sourceId, layerIds } = await loadLayer(this.map, url, {
        color: el.dataset.color,
        outlineColor: el.dataset.outlineColor || el.dataset['outline-color'],
      })
      this._remember(sourceId, layerIds)

      // optional fit when enabling
      const fit = el.dataset.fit ? el.dataset.fit !== 'false' : true
      if (fit) {
        const b = boundsFrom(fc)
        if (!b.isEmpty()) this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 0 })
      }
    } else {
      // derive id from URL and remove that source+layers
      const sourceId = this._sourceIdFromUrl(url)
      this._forget(sourceId)
      removeSourceLayers(this.map, sourceId)
    }
  }

  // // (UNUSED) Button: uncheck all layer toggles and remove all remembered layers/sources
  // clearLayers() {
  //   this.element
  //     .querySelectorAll('input.form-check-input[type="checkbox"]')
  //     .forEach(cb => { cb.checked = false })
  //   this._removeAllLayersAndSources() // DOM marker persists
  // }

  // // (UNUSED) Button: reset camera to initial center/zoom and ensure DOM marker at community
  // resetView() {
  //   this._removeAllLayersAndSources()
  //   this.map.flyTo({ center: this.mapCenterValue, zoom: DEFAULT_ZOOM, essential: true })

  //   // ensure static DOM marker exists at the community coords
  //   const [lng0, lat0] =
  //     (this.hasMarkersValue && this.markersValue[0]) || this.mapCenterValue
  //   const L0 = Number(lng0), A0 = Number(lat0)

  //   this._domMarker = upsertDomMarker(this._domMarker, this.map, {
  //     lng: L0, lat: A0, title: this.markerTooltipTitleValue
  //   })
  // }

  // Click from outside the map panel: load a layer and sync the map panel checkbox
  async showLayer(event) {
    const el = event.currentTarget;
    const url = el.dataset.url || el.dataset.layerUrl || el.dataset.mapLayerUrl;
    if (!url) return;

    const color = el.dataset.color;
    const outlineColor = el.dataset.outlineColor || el.dataset['outline-color'];
    const fit = el.dataset.fit ? el.dataset.fit !== 'false' : true;

    await this._ensureMapReady();

    // Load (idempotent: addSource updates existing; addLayer guards by id)
    const { fc, sourceId, layerIds } = await loadLayer(this.map, url, { color, outlineColor });
    this._remember(sourceId, layerIds);

    if (fit) {
      const b = boundsFrom(fc);
      if (!b.isEmpty()) this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 0 });
    }

    // Sync the matching checkbox so UI reflects the map state
    const cb = this._findCheckboxForUrl(url, el.dataset.checkboxId);
    if (cb && !cb.checked) cb.checked = true;
  }

  // ---- helpers  ----

  // --- helpers for showLayer ---
  async _ensureMapReady() {
    if (!this.map) throw new Error('Map not initialized');
    if (!this.map.isStyleLoaded()) await new Promise((r) => this.map.once('load', r));
  }
    // Prefer an explicit checkbox id; otherwise match by data-url
  _findCheckboxForUrl(url, checkboxId) {
    if (checkboxId) return document.getElementById(checkboxId);
    // Try inside this controller’s element first, then anywhere on the page as a fallback
    const sel = `input.form-check-input[data-url="${this._cssEscape(url)}"]`;
    return this.element.querySelector(sel) || document.querySelector(sel);
  }

  // Minimal CSS escaper for attribute selectors
  _cssEscape(s = '') { return String(s).replace(/["\\]/g, '\\$&'); }

  /// ------------------------------------------

  // Stable source id for the marker layer namespace (per-controller element)
  _markerSourceId() {
    return `marker:${this.element.id || 'map'}`
  }

  // Build a FeatureCollection from `markersValue` for layer-based markers
  _markerFC() {
    return featureCollectionFromLngLats(this.hasMarkersValue ? this.markersValue : [], {
      title: this.markerTooltipTitleValue
    })
  }

  // Convert a URL path into a safe, deterministic source id
  _sourceIdFromUrl(url) {
    return new URL(url, window.location.origin).pathname.replace(/[^\w-]/g, ':')
  }

  // Track added layer/source ids for later cleanup
  _remember(sourceId, layerIds) {
    if (!this.sourceIds.includes(sourceId)) this.sourceIds.push(sourceId)
    for (const id of layerIds) if (!this.layerIds.includes(id)) this.layerIds.push(id)
    const set = this.layersBySource.get(sourceId) || new Set()
    layerIds.forEach((id) => set.add(id))
    this.layersBySource.set(sourceId, set)
  }

  // Forget a specific source and its layer ids in our bookkeeping
  _forget(sourceId) {
    const set = this.layersBySource.get(sourceId)
    if (set) {
      for (const id of set) this.layerIds = this.layerIds.filter((x) => x !== id)
      this.layersBySource.delete(sourceId)
    }
    this.sourceIds = this.sourceIds.filter((x) => x !== sourceId)
  }

  // Remove all remembered layers/sources from the map and clear bookkeeping
  _removeAllLayersAndSources() {
    this.layerIds.splice(0).forEach((id) => { if (this.map?.getLayer(id)) this.map.removeLayer(id) })
    this.sourceIds.splice(0).forEach((id) => { if (this.map?.getSource(id)) this.map.removeSource(id) })
    this.layersBySource.clear()
  }
}