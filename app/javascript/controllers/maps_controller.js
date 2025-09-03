import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static targets = ['map', 'loading'];
  static values = {
    token: String,
    mapCenter: { type: Array, default: [-154.49, 63.58] },
    defaultLayerUrl: String,
    markers: Array,
    markerTooltipTitle: { type: String, default: 'Location' },
  };

  connect() {
    mapboxgl.accessToken = this.tokenValue;

    this.activeLayers = [];
    this.activeSources = [];
    this._marker = null; // single marker instance

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/streets-v11?optimize=true',
      center: this.mapCenterValue,
      zoom: 4,
    });

    this.map.on('load', () => {
      if (this.hasDefaultLayerUrlValue) {
        this.loadLayer(this.defaultLayerUrlValue);
      }

      if (this.hasMarkersValue) {
        this.markersValue.forEach((coord) => this.addMarker(coord));
      }
    });

    this._onSelectLayer = (e) => {
      const { url, color, outlineColor, clear: shouldClear } = e.detail || {};
        if (!url) return;

        if (shouldClear !== false) {
          this.clearAllLayers();
        }

        this.loadLayer(url, { color, outlineColor });
    };
    window.addEventListener("maps:select-layer", this._onSelectLayer);
  }

  addMarker([lng, lat]) {
    this.clearMarker();

    const marker = new mapboxgl.Marker().setLngLat([lng, lat]).addTo(this.map);
    this.setupMarkerTooltip(marker, [lng, lat], this.markerTooltipTitleValue);

    this._marker = marker;
  }

  setupMarkerTooltip(marker, [lng, lat], title) {
    const popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: true,
      closeOffClick:true,
      closeOnMove: false, 
      offset: 10,
    }).setHTML(`
    <div>
      <strong>${title}</strong><br/>
      Lat: ${lat.toFixed(4)}<br/>
      Lng: ${lng.toFixed(4)}
    </div>
  `);

    // attach popup to marker so togglePopup/getPopup work
    marker.setPopup(popup);
  }

  setupFillLayerTooltip(fillLayerId) {
    this._popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: false,
      offset: 10,
    });

    this._tooltipMouseMove = (e) => {
      this.map.getCanvas().style.cursor = 'pointer';

      const feature = e.features[0];
      const tooltip = feature.properties.tooltip;

      if (tooltip) {
        this._popup
          .setLngLat(e.lngLat)
          .setHTML(`<div>${tooltip}</div>`)
          .addTo(this.map);
      }
    };

    this._tooltipMouseLeave = () => {
      this.map.getCanvas().style.cursor = '';
      this._popup.remove();
    };

    this.map.on('mousemove', fillLayerId, this._tooltipMouseMove);
    this.map.on('mouseleave', fillLayerId, this._tooltipMouseLeave);
  }

  clearFillLayerTooltip() {
    if (!this._tooltipMouseMove || !this._tooltipMouseLeave) return;

    this.activeLayers.forEach((layerId) => {
      if (this.map.getLayer(layerId)) {
        this.map.off('mousemove', layerId, this._tooltipMouseMove);
        this.map.off('mouseleave', layerId, this._tooltipMouseLeave);
      }
    });

    this._popup?.remove();
    this._popup = null;
    this._tooltipMouseMove = null;
    this._tooltipMouseLeave = null;
  }

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

    resetView() {
    // clear layers but leave marker
    this.clearAllLayers();

    // reset map position to the original center/zoom
    this.map.flyTo({
      center: this.mapCenterValue,
      zoom: 4,
      essential: true
    });

    // if you had a marker set initially, make sure it’s still visible
    if (this.hasMarkersValue && this.markersValue.length > 0) {
      const [lng, lat] = this.markersValue[0];
      if (!this._marker) {
        this.addMarker([lng, lat]);
      }
    }
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

  async loadLayer(url, options = {}) {
    this.showLoading();
    try {
      this.clearAllLayers();
      this.clearFillLayerTooltip();

      const res = await fetch(url);
      if (!res.ok) throw new Error(`Fetch failed: ${res.status}`);
      const geojson = await res.json();

      const layerName = new URL(url, window.location.origin).pathname
        .split('/')
        .pop();

      this.map.addSource(layerName, {
        type: 'geojson',
        data: geojson,
      });

      this.activeSources.push(layerName);

      const fillId = `${layerName}-fill`;
      const outlineId = `${layerName}-outline`;

      this.map.addLayer({
        id: fillId,
        type: 'fill',
        source: layerName,
        paint: {
          'fill-color': options.color || '#088',
          'fill-opacity': 0.4,
        },
      });

      this.setupFillLayerTooltip(fillId);

      this.map.addLayer({
        id: outlineId,
        type: 'line',
        source: layerName,
        paint: {
          'line-color': options.outlineColor || '#05505e',
          'line-width': 2,
          'line-opacity': 0.8,
        },
      });

      this.activeLayers.push(fillId, outlineId);

      const bounds = this.getBoundsAround(geojson);

      if (!bounds.isEmpty()) {
        this.map.fitBounds(bounds, { padding: 40, maxZoom: 10, duration: 1000 });
      }
    } catch (err) {
      console.error('Error loading layer:', err);
    } finally {
      this.hideLoading();
    }
  }

  clearAllLayers() {
    this.activeLayers.forEach((layerId) => {
      if (this.map.getLayer(layerId)) {
        this.map.removeLayer(layerId);
      }
    });
    this.activeLayers = [];

    this.activeSources.forEach((sourceId) => {
      if (this.map.getSource(sourceId)) {
        this.map.removeSource(sourceId);
      }
    });
    this.activeSources = [];
  }

  selectLayer(event) {
    this.clearAllLayers();
    const button = event.currentTarget;
    const url = button.dataset.url;
    const color = button.dataset.color;
    const outlineColor = button.dataset.outlineColor;
    this.loadLayer(url, { color, outlineColor });
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

  showMarker(event) {
    const { lng, lat, title } = event.params;
    const L = parseFloat(lng), A = parseFloat(lat);

    this._marker = new mapboxgl.Marker().setLngLat([L, A]).addTo(this.map);
    this.setupMarkerTooltip(this._marker, [L, A], title);
    // open immediately
    this._marker.togglePopup();
    // auto-close after 2 seconds
    setTimeout(() => {
      if (this._marker?.getPopup()) { this._marker.getPopup().remove(); } }, 2000);
    this.map.flyTo({ center: [L, A], essential: true });
  }

  disconnect() {
    // 1) detach external listeners/timers
    window.removeEventListener("maps:select-layer", this._onSelectLayer);
    clearTimeout(this._markerPopupTimer);

    // 2) remove map-bound handlers (tooltips, etc.)
    try {
      // if you set these earlier, unbind them safely
      if (this._tooltipMouseMove || this._tooltipMouseLeave) {
        this.activeLayers.forEach((layerId) => {
          if (this.map?.getLayer(layerId)) {
            this.map.off('mousemove', layerId, this._tooltipMouseMove);
            this.map.off('mouseleave', layerId, this._tooltipMouseLeave);
          }
        });
      }
      this._popup?.remove();
    } catch (_) {}

    // 3) clear overlays you created
    this.clearAll?.(); // clears marker + layers (guards inside)

    // 4) remove the map ONCE, with a guard
    if (this.map) {
      try {
        this.map.remove();
      } catch (e) {
        console.warn('Mapbox remove() failed, ignoring:', e);
      } finally {
        this.map = null;
      }
    }
  }
}
