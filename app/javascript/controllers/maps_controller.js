import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

const MAP_STYLE = 'mapbox://styles/mapbox/streets-v11?optimize=true';
const DEFAULT_ZOOM = 8;

export default class extends Controller {
  // 1) Static config
  static targets = ['map', 'loading'];
  static values = {
    token: String,
    mapCenter: { type: Array, default: [-154.49, 63.58] },
    defaultLayerUrl: String,
    markers: Array,
    markerTooltipTitle: { type: String, default: 'Location' },
  };

  // 2) Lifecycle
  connect() {
    mapboxgl.accessToken = this.tokenValue;

    this.activeLayers = [];
    this.activeSources = [];
    this._marker = null;
    this._hoverPopup = null;
    this._layerHandlers = new Map(); // layerId -> { mouseenter, mousemove, mouseleave }

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: MAP_STYLE,
      center: this.mapCenterValue,
      zoom: DEFAULT_ZOOM,
    });

    this.map.on('load', () => {
      if (this.hasDefaultLayerUrlValue)
        this.loadLayer(this.defaultLayerUrlValue);
      if (this.hasMarkersValue)
        this.markersValue.forEach((coord) => this.addMarker(coord));
    });

    this._onSelectLayer = (e) => {
      const { url, color, outlineColor, clear: shouldClear } = e.detail || {};
      if (!url) return;
      if (shouldClear !== false) this.clearAllLayers();
      this.loadLayer(url, { color, outlineColor });
    };
    window.addEventListener('maps:select-layer', this._onSelectLayer);
  }

  disconnect() {
    window.removeEventListener('maps:select-layer', this._onSelectLayer);
    this._unbindHoverPopups();
    this.clearAll();

    if (this.map) {
      try {
        this.map.remove();
      } catch (_) {}
      this.map = null;
    }
  }

  // 3) Public actions (used by data-action or other controllers)
  resetView() {
    this.clearAllLayers();

    // reset map position to the original center/zoom
    this.map.flyTo({
      center: this.mapCenterValue,
      zoom: DEFAULT_ZOOM,
      essential: true,
    });

    // if you had a marker set initially, make sure it’s still visible
    if (this.hasMarkersValue && this.markersValue.length > 0 && !this._marker) {
      const [lng, lat] = this.markersValue[0];
      this.addMarker([lng, lat]);
    }
  }

  selectLayer(event) {
    const el = event.currentTarget;
    this.loadLayer(el.dataset.url, {
      color: el.dataset.color,
      outlineColor: el.dataset.outlineColor,
    });
  }

  showMarker(event) {
    const { lng, lat, title } = event.params;
    const L = parseFloat(lng),
      A = parseFloat(lat);
    this._showMarkerAt([L, A], title);
    this._marker?.togglePopup();
    setTimeout(() => this._marker?.getPopup()?.remove(), 2000);
    this.map.flyTo({ center: [L, A], essential: true });
  }

  addMarker([lng, lat], title = this.markerTooltipTitleValue) {
    this._marker = new mapboxgl.Marker().setLngLat([lng, lat]).addTo(this.map);
    this._showMarkerAt([lng, lat], title);
  }

  clearMarker() {
    if (this._marker) {
      this._marker.remove();
      this._marker = null;
    }
  }

  clearAll() {
    this.clearMarker();
    this.clearAllLayers();
  }

  // 4) Data loading
  async loadLayer(url, opts = {}) {
    this.showLoading();
    try {
      if (!this.map) throw new Error('Map not initialized');

      if (!this.map.isStyleLoaded()) {
        await new Promise((resolve) => this.map.once('load', resolve));
      }

      this.clearAllLayers();

      const res = await fetch(url, { headers: { Accept: 'application/json' } });
      if (!res.ok) throw new Error(`Fetch failed: ${res.status}`);
      const fc = await res.json();

      const id = this._layerId(url);
      this._addSource(id, fc);

      const kind = this._geomKind(fc);
      if (kind === 'poly') this._addPolygonLayers(id, opts);
      if (kind === 'point') this._addPointLayer(id);

      this._fitTo(fc);
    } catch (e) {
      console.error('Error loading layer:', e);
    } finally {
      this.hideLoading();
    }
  }

  // 5) Layer management
  clearAllLayers() {
    // remove layers
    this.activeLayers.forEach((layerId) => {
      if (this.map.getLayer(layerId)) this.map.removeLayer(layerId);
    });
    this.activeLayers = [];

    // remove sources
    this.activeSources.forEach((sourceId) => {
      if (this.map.getSource(sourceId)) this.map.removeSource(sourceId);
    });
    this.activeSources = [];

    // unbind hover events + popups
    this._unbindHoverPopups();
  }

  _addPolygonLayers(id, { color = '#088', outlineColor = '#05505e' } = {}) {
    const fillId = `${id}-fill`;
    const lineId = `${id}-outline`;

    if (!this.map.getLayer(fillId)) {
      this.map.addLayer({
        id: fillId,
        type: 'fill',
        source: id,
        paint: { 'fill-color': color, 'fill-opacity': 0.4 },
      });
      this.activeLayers.push(fillId);

      // unified hover popup
      this._bindHoverPopup(
        fillId,
        (e) => [e.lngLat.lng, e.lngLat.lat],
        (f) =>
          f.properties?.tooltip ||
          f.properties?.title ||
          this.markerTooltipTitleValue
      );
    }

    if (!this.map.getLayer(lineId)) {
      this.map.addLayer({
        id: lineId,
        type: 'line',
        source: id,
        paint: {
          'line-color': outlineColor,
          'line-width': 2,
          'line-opacity': 0.8,
        },
      });
      this.activeLayers.push(lineId);
    }
  }

  _addPointLayer(id) {
    const ptsId = `${id}_points`;
    if (this.map.getLayer(ptsId)) return;

    this.map.addLayer({
      id: ptsId,
      type: 'circle',
      source: id,
      filter: ['==', ['geometry-type'], 'Point'],
      paint: {
        'circle-radius': 6,
        'circle-color': '#EE4B2B',
        'circle-stroke-width': 1,
        'circle-stroke-color': '#fff',
      },
    });
    this.activeLayers.push(ptsId);

    // unified hover popup
    this._bindHoverPopup(
      ptsId,
      (e) => {
        const f = e.features?.[0];
        return f?.geometry?.coordinates || [e.lngLat.lng, e.lngLat.lat];
      },
      (f) =>
        f.properties?.tooltip || f.properties?.title || this.markerTooltipTitleValue
    );
  }

  // 6) UI state
  showLoading() {
    if (!this.hasLoadingTarget) return;
    this.loadingTarget.classList.remove('d-none');
    this.loadingTarget.innerHTML =
      '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span> Loading...';
  }

  hideLoading() {
    if (!this.hasLoadingTarget) return;
    this.loadingTarget.classList.add('d-none');
  }

  // 7) Popups and tooltips (unified)
  _bindHoverPopup(layerId, getLngLat, getTitle) {
    if (!this._hoverPopup) {
      this._hoverPopup = new mapboxgl.Popup({
        closeButton: false,
        closeOnClick: false,
        offset: 10,
      });
    }

    const onEnter = () => this._setCursor('pointer');
    const onMove = (e) => {
      const f = e.features?.[0];
      if (!f) return;
      const [lng, lat] = getLngLat(e, f);
      const title = getTitle(f, e) || this.markerTooltipTitleValue;
      this._hoverPopup
        .setLngLat([lng, lat])
        .setHTML(this._popupHtml(title, lng, lat))
        .addTo(this.map);
    };
    const onLeave = () => {
      this._setCursor('');
      this._hoverPopup.remove();
    };

    this.map.on('mouseenter', layerId, onEnter);
    this.map.on('mousemove', layerId, onMove);
    this.map.on('mouseleave', layerId, onLeave);

    this._layerHandlers.set(layerId, { onEnter, onMove, onLeave });
  }

  _unbindHoverPopups() {
    for (const [layerId, h] of this._layerHandlers.entries()) {
      if (this.map?.getLayer(layerId)) {
        this.map.off('mouseenter', layerId, h.onEnter);
        this.map.off('mousemove', layerId, h.onMove);
        this.map.off('mouseleave', layerId, h.onLeave);
      }
    }
    this._layerHandlers.clear();
    this._hoverPopup?.remove();
  }

  _showMarkerAt([lng, lat], title = this.markerTooltipTitleValue) {
    const popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: true,
      offset: 10,
    }).setHTML(this._popupHtml(title, lng, lat));
    this._marker.setPopup(popup);
  }

  _popupHtml(title, lng, lat) {
    return `
      <div>
        <strong>${title}</strong><br/>
        ${Number(lat).toFixed(4)}, ${Number(lng).toFixed(4)}
      </div>
    `;
    // If you later want richer content, centralize it here.
  }

  // 8) Geometry helpers
  _geomKind(fc) {
    const t = fc?.features?.[0]?.geometry?.type || '';
    return /Point$/i.test(t) ? 'point' : /Polygon$/i.test(t) ? 'poly' : 'other';
  }

  _fitTo(fc) {
    const b = this.getBoundsAround(fc);
    if (!b.isEmpty())
      this.map.fitBounds(b, { padding: 40, maxZoom: 10, duration: 1000 });
  }

  getBoundsAround(geojson) {
    const bounds = new mapboxgl.LngLatBounds();
    const extendRecurse = (coords) => {
      if (typeof coords[0] === 'number') {
        // we're only dealing with polygons/points that should be in the state of Alaska
        // if any points are west of the anti-meridian, re-wrap them
        // I'm choosing 170 here because the "eastern" most point of Alaska is 172E (Attu Island)
        if (coords[0] > 170) {
          coords[0] = (coords[0] % 360) - 360;
        }
        bounds.extend(coords);
      } else {
        coords.forEach(extendRecurse);
      }
    };

    for (const f of geojson.features) extendRecurse(f.geometry.coordinates);
    return bounds;
  }

  // 9) Misc helpers
  _setCursor(v) {
    this.map.getCanvas().style.cursor = v;
  }

  _layerId(url) {
    return new URL(url, window.location.origin).pathname.split('/').pop();
  }

  _addSource(id, data) {
    this.map.addSource(id, { type: 'geojson', data });
    this.activeSources.push(id);
  }
}
