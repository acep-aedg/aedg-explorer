import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static targets = ['map'];
  static values = {
    token: String,
    mapCenter: Array,
    defaultLayerUrl: String,
    markers: Array,
  };

  connect() {
    mapboxgl.accessToken = this.tokenValue;

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

  async loadLayer(url, options = {}) {
    try {
      console.log('Loading layer from:', url);

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

      this.map.addLayer({
        id: `${layerName}-fill`,
        type: 'fill',
        source: layerName,
        paint: {
          'fill-color': options.color || '#088',
          'fill-opacity': 0.4,
        },
      });

      this.map.addLayer({
        id: `${layerName}-outline`,
        type: 'line',
        source: layerName,
        paint: {
          'line-color': options.outlineColor || '#05505e',
          'line-width': 2,
          'line-opacity': 0.8,
        },
      });

    } catch (err) {
      console.error('Error loading layer:', err);
    }
  }


  selectLayer(event) {
    const url = event.currentTarget.dataset.url;
    const color = event.currentTarget.dataset.color;
    const outlineColor = event.currentTarget.dataset.outlineColor;

    this.loadLayer(url, { color, outlineColor });
  }
}
