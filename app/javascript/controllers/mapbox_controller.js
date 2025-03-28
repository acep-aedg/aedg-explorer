// app/javascript/controllers/mapbox_controller.js
import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    token: String,
  };

  connect() {
    console.log('Mapbox controller connected');
    this.initMapbox();
  }

  initMapbox() {
    mapboxgl.accessToken = this.tokenValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [-98.5795, 39.8283],
      zoom: 4
    });
  }
}
