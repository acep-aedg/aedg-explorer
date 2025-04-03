import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

function collectBoundsFromGeoJSON(data) {
  return data.features.reduce((bounds, feature) => {
    const coords = feature.geometry.coordinates;
    const type = feature.geometry.type;

    const extend = (coord) => {
      bounds = bounds
        ? bounds.extend(coord)
        : new mapboxgl.LngLatBounds(coord, coord);
    };

    if (type === 'Polygon') {
      coords[0].forEach(extend);
    } else if (type === 'MultiPolygon') {
      coords.forEach((polygon) => polygon[0].forEach(extend));
    }

    return bounds;
  }, null);
}

export default class extends Controller {
  static values = {
    token: String,
    houseUrl: String,
    senateUrl: String,
    mapCenter: Array,
  };

  connect() {
    mapboxgl.accessToken = this.tokenValue;

    this.layers = [
      {
        name: 'house-districts',
        fillId: 'house-fill',
        outlineId: 'house-outline',
        label: 'House Districts',
        color: '#088',
        outlineColor: '#05505e',
        urlValue: this.houseUrlValue,
      },
      {
        name: 'senate-districts',
        fillId: 'senate-fill',
        outlineId: 'senate-outline',
        label: 'Senate Districts',
        color: '#e67e22',
        outlineColor: '#a84300',
        urlValue: this.senateUrlValue,
      },
    ];

    this._boundsExtended = false;
    this.fetchAllLayers(); 
    this.initMap();
  }

  initMap() {
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v11?optimize=true',
      center: this.mapCenterValue || [-149.9, 61.2],
      zoom: 6,
    });

    this.map.on('load', () => {
      this.fillLayerIds = this.layers.map((l) => l.fillId);
      this.addLegend();
      this.setupTooltip();
    });
  }

  async fetchAllLayers() {
    const allBounds = [];

    await Promise.all(
      this.layers.map(async (layer) => {
        try {
          const res = await fetch(layer.urlValue);
          const geojson = await res.json();

          const bounds = collectBoundsFromGeoJSON(geojson);
          if (bounds) allBounds.push(bounds);

          const load = () => this.loadGeoJSON(geojson, layer);
          this.map.loaded() ? load() : this.map.once('load', load);
        } catch (err) {
          console.error(`Failed to fetch ${layer.name}`, err);
        }
      })
    );

    if (allBounds.length) {
      const finalBounds = allBounds.reduce(
        (acc, b) => acc.extend(b),
        allBounds[0]
      );
      this.map.fitBounds(finalBounds, {
        padding: 40,
        maxZoom: 10,
        duration: 1000,
      });
    }
  }

  loadGeoJSON(data, { name, fillId, outlineId, color, outlineColor }) {
    if (!this.map.getSource(name)) {
      this.map.addSource(name, { type: 'geojson', data });

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
  }

  setupTooltip() {
    let lastMove = 0;

    this.map.on('mousemove', (e) => {
      const now = Date.now();
      if (now - lastMove < 50) return;
      lastMove = now;

      const features = this.map.queryRenderedFeatures(e.point, {
        layers: this.fillLayerIds,
      });

      const seen = new Set();
      const tooltips = [];

      for (const feature of features) {
        const id = feature.layer.id;
        if (!seen.has(id)) {
          seen.add(id);
          const tooltip = feature.properties.tooltip;
          if (tooltip) tooltips.push(`<div>${tooltip}</div>`);
        }
      }

      if (tooltips.length > 0) {
        this.popup?.remove();
        this.popup = new mapboxgl.Popup({
          closeButton: false,
          closeOnClick: false,
        })
          .setLngLat(e.lngLat)
          .setHTML(
            `<strong>Legislative Districts</strong><div class="mt-1">${tooltips.join(
              ''
            )}</div>`
          )
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
    legend.className =
      'map-legend position-absolute bg-white p-2 rounded shadow-sm small';
    legend.style.top = '10px';
    legend.style.left = '10px';
    legend.style.zIndex = '1';

    this.layers.forEach(({ fillId, outlineId, label }) => {
      const labelEl = document.createElement('label');
      labelEl.classList.add(
        'form-check',
        'form-check-label',
        'd-block',
        'mb-1'
      );

      const checkbox = document.createElement('input');
      checkbox.type = 'checkbox';
      checkbox.className = 'form-check-input me-1';
      checkbox.checked = true;
      checkbox.dataset.layerId = fillId;
      checkbox.dataset.outlineId = outlineId;
      checkbox.addEventListener('change', this.toggleLayer.bind(this));

      const span = document.createElement('span');
      span.textContent = label;

      labelEl.appendChild(checkbox);
      labelEl.appendChild(span);
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
