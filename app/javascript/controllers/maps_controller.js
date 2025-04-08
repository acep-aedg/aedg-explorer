import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static targets = ['map', 'loading'];
  static values = {
    token: String,
    mapCenter: Array,
    defaultLayerUrl: String,
    markers: Array,
  };

  connect() {
    mapboxgl.accessToken = this.tokenValue;

    this.activeLayers = [];
    this.activeSources = [];

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/streets-v11?optimize=true',
      center: this.mapCenterValue || [-149.9, 61.2],
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
  }

  addMarker([lng, lat]) {
    new mapboxgl.Marker().setLngLat([lng, lat]).addTo(this.map);
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

  getBounds(geojson) {
    const bounds = new mapboxgl.LngLatBounds();

    for (const feature of geojson.features) {
      const coords = feature.geometry.coordinates;
      const type = feature.geometry.type;

      if (type === 'Point') {
        bounds.extend(coords);
      } else {
        // For Polygon and MultiPolygon, drill into the first level of nested coords
        const recurse = (c) => {
          if (typeof c[0] === 'number') {
            bounds.extend(c);
          } else {
            c.forEach(recurse);
          }
        };
        recurse(coords);
      }
    }

    return bounds;
  }
  async loadLayer(url, options = {}) {
    this.showLoading();
    try {
      this.clearAllLayers();

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
      const bounds = this.getBounds(geojson);
      if (!bounds.isEmpty()) {
        this.map.fitBounds(bounds, {
          padding: 40,
          maxZoom: 10,
          duration: 1000,
        });
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

  async selectLayer(event) {
    const button = event.currentTarget;
    const url = button.dataset.url;
    const color = button.dataset.color;
    const outlineColor = button.dataset.outlineColor;

    button.parentElement
      .querySelectorAll('.btn')
      .forEach((btn) => btn.classList.remove('active'));

    button.classList.add('active');

    this.loadLayer(url, { color, outlineColor });
  }
}
