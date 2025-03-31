// app/javascript/controllers/mapbox_controller.js
import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    token: String,
    dataUrl: String,
  };

  connect() {
    mapboxgl.accessToken = this.tokenValue;
    this.initMap();
  }

  initMap() {
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [-149.9, 61.2],
      zoom: 7,
    });

    this.map.on('load', () => {
      if (this.hasDataUrlValue) {
        this.loadGeoJSONFromUrl(this.dataUrlValue);
      }
    });
  }

  loadGeoJSONFromUrl(url) {
    fetch(url)
      .then((response) => response.json())
      .then((data) => {
        this.map.addSource('geojson-data', {
          type: 'geojson',
          data: data,
        });

        this.map.addLayer({
          id: 'geojson-layer',
          type: 'fill',
          source: 'geojson-data',
          paint: {
            'fill-color': '#088',
            'fill-opacity': 0.4,
          },
        });

        this.map.addLayer({
          id: 'geojson-outline',
          type: 'line',
          source: 'geojson-data',
          paint: {
            'line-color': '#088',
            'line-width': 2,
            'line-opacity': 1,
          },
        });

        // Add popup interaction
        this.map.on('mousemove', 'geojson-layer', (e) => {
          const tooltip = e.features[0].properties.tooltip;
          this.popup?.remove(); // remove any existing popup

          this.popup = new mapboxgl.Popup({
            closeButton: false,
            closeOnClick: false,
          })
            .setLngLat(e.lngLat)
            .setHTML(`<strong>${tooltip}</strong>`)
            .addTo(this.map);
        });

        this.map.on('mouseleave', 'geojson-layer', () => {
          this.popup?.remove();
          this.popup = null;
        });
      })
      .catch((error) => {
        console.error('Failed to load GeoJSON:', error);
      });
  }
}
