// app/javascript/controllers/mapbox_controller.js
import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    token: String,
    dataUrl: String,
    mapCenter: Array
  };

  connect() {
    mapboxgl.accessToken = this.tokenValue;
    this.initMap();
  }

  initMap() {
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v11',
      center: this.mapCenterValue,
      zoom: 7,
    });

    this.layers = [
      {
        name: 'house-districts',
        fillId: 'house-fill',
        outlineId: 'house-outline',
        label: 'House Districts',
        color: '#088',
        outlineColor: '#05505e',
        key: 'house',
      },
      {
        name: 'senate-districts',
        fillId: 'senate-fill',
        outlineId: 'senate-outline',
        label: 'Senate Districts',
        color: '#e67e22',
        outlineColor: '#a84300',
        key: 'senate',
      },
    ];

    this.map.on('load', () => {
      fetch(this.dataUrlValue)
        .then((res) => res.json())
        .then((data) => {
          this.layers.forEach((layer) => {
            const geojson = data[layer.key];
            if (geojson) this.loadGeoJSON(geojson, layer);
          });

          this.addLegend();
          this.setupTooltip();
        })
        .catch((err) =>
          console.error('Failed to load legislative districts:', err)
        );
    });
  }

  loadGeoJSON(data, { name, fillId, outlineId, color, outlineColor }) {
    this.map.addSource(name, {
      type: 'geojson',
      data: data,
    });

    this.map.addLayer({
      id: fillId,
      type: 'fill',
      source: name,
      paint: {
        'fill-color': color,
        'fill-opacity': 0.4,
      },
    });

    this.map.addLayer({
      id: outlineId,
      type: 'line',
      source: name,
      paint: {
        'line-color': outlineColor,
        'line-width': 2,
        'line-opacity': 0.8,
      },
    });
  }

  setupTooltip() {
    this.map.on('mousemove', (e) => {
      const allLayers = this.layers.map((layer) => layer.fillId);
      const features = this.map.queryRenderedFeatures(e.point, {
        layers: allLayers,
      });

      const seenLayers = new Set();
      const districtTooltips = [];

      for (const feature of features) {
        const layerId = feature.layer.id;
        if (!seenLayers.has(layerId)) {
          seenLayers.add(layerId);
          const tooltip = feature.properties.tooltip;
          if (tooltip) districtTooltips.push(`<div>${tooltip}</div>`);
        }
      }

      if (districtTooltips.length > 0) {
        const html = `
        <strong>Legislative Districts</strong>
        <div style="margin-top: 4px;">
          ${districtTooltips.join('')}
        </div>
      `;

        this.popup?.remove();
        this.popup = new mapboxgl.Popup({
          closeButton: false,
          closeOnClick: false,
        })
          .setLngLat(e.lngLat)
          .setHTML(html)
          .addTo(this.map);
      } else {
        this.popup?.remove();
        this.popup = null;
      }
    });

    this.layers.forEach(({ fillId }) => {
      this.map.on('mouseleave', fillId, () => {
        this.popup?.remove();
        this.popup = null;
      });
    });
  }

  addLegend() {
    const legend = document.createElement('div');
    legend.className = 'map-legend';
    legend.style.cssText = `
      position: absolute;
      top: 10px;
      left: 10px;
      background: white;
      padding: 8px;
      border-radius: 6px;
      box-shadow: 0 0 6px rgba(0,0,0,0.1);
      font-size: 14px;
      z-index: 1;
    `;

    this.layers.forEach(({ fillId, outlineId, label }) => {
      const labelEl = document.createElement('label');
      labelEl.style.display = 'block';
      labelEl.style.marginBottom = '4px';

      const checkbox = document.createElement('input');
      checkbox.type = 'checkbox';
      checkbox.checked = true;
      checkbox.dataset.layerId = fillId;
      checkbox.dataset.outlineId = outlineId;
      checkbox.addEventListener('change', this.toggleLayer.bind(this));

      labelEl.appendChild(checkbox);
      labelEl.appendChild(document.createTextNode(` ${label}`));
      legend.appendChild(labelEl);
    });

    this.element.parentElement.appendChild(legend);
  }

  toggleLayer(event) {
    const fillId = event.target.dataset.layerId;
    const outlineId = event.target.dataset.outlineId;
    const visible = event.target.checked ? 'visible' : 'none';

    if (this.map.getLayer(fillId)) {
      this.map.setLayoutProperty(fillId, 'visibility', visible);
    }
    if (this.map.getLayer(outlineId)) {
      this.map.setLayoutProperty(outlineId, 'visibility', visible);
    }
  }
}
