import mapboxgl from 'mapbox-gl';
import { LAYER_COLORS } from './config.js';

let activePopup = null;
let clickableLayers = new Set();

export function trackPopup(popupInstance) {
  activePopup = popupInstance;
  activePopup.on('close', () => { activePopup = null; });
}

function getLegendColorForFeature(map, feature) {
  const layerId = feature.layer?.id || "";
  
  // Grab everything after the final colon
  const parts = layerId.split(':');
  const fileName = parts[parts.length - 1] || "";
  
  // Clean: Remove Mapbox suffixes and convert underscores to dashes
  const slug = fileName
    .replace(/-(fill|outline|circle|line|points)$/, "")
    .replace(/_/g, "-");

  // Match: Look up the cleaned slug in your LAYER_COLORS
  if (LAYER_COLORS[slug]) {
    return LAYER_COLORS[slug];
  }

  // Fallback: Match "community_locations" for the base layer
  if (slug === "communities" || slug === "community_locations") {
    return LAYER_COLORS["community_locations"];
  }

  return '#333333'; 
}

export function defaultPopupTemplate(map, f) {
  const p = f.properties || {};
  const themeColor = getLegendColorForFeature(map, f);

  const title = p.title || p.name || p.Layer || 'Location Detail';
  const category = p.category || (p.isMarker ? "Community" : "Map Feature");

  let contentData = p.content || {};
  if (typeof contentData === 'string') {
    try { contentData = JSON.parse(contentData); } catch (e) { contentData = {}; }
  }

  const bodyContent = Object.entries(contentData)
    .map(([label, value]) => {
      let displayValue = (typeof value === 'number') ? value.toLocaleString() : value;
      if (label.startsWith("_")) return `<li class="location-item">${displayValue}</li>`;
      return `<div class="data-row"><strong>${label}:</strong> ${displayValue}</div>`;
    })
    .join('');

  return `
    <div class="popup-inner">
      <div class="popup-header">
        <li class="popup-category">${category}</li>
        <p>${title}</p>
      </div>
      ${bodyContent ? `<ul class="popup-body">${bodyContent}</ul>` : ''}
      ${p.path ? `<a href="${p.path}" class="popup-link">View Profile →</a>` : ''}
      <div class="popup-accent-bar" style="background-color: ${themeColor};"></div>
    </div>
  `;
}

export function detachPopup(layerId) {
  clickableLayers.delete(layerId);
}

function updateHighlight(map, features) {
  const source = map.getSource('feature-highlight');
  if (!source) return;

  const highlightFeatures = (features || []).map(f => {
    const color = getLegendColorForFeature(map, f);
    return {
      type: 'Feature',
      geometry: f.geometry,
      properties: { stroke: color }
    };
  });

  source.setData({
    type: 'FeatureCollection',
    features: highlightFeatures
  });
}

export function attachPopup(map, layerId) {
  clickableLayers.add(layerId);

  map.on('mouseenter', layerId, () => { map.getCanvas().style.cursor = 'pointer'; });
  map.on('mouseleave', layerId, () => { map.getCanvas().style.cursor = ''; });

  if (!map._hasGlobalClickHandler) {
    map.on('click', (e) => {
      const activeLayers = Array.from(clickableLayers).filter(id => map.getLayer(id));
      if (activeLayers.length === 0) return;

      const rawFeatures = map.queryRenderedFeatures(e.point, { layers: activeLayers });

      // FILTER: Remove duplicates by keeping only one feature per unique source
      // This prevents double-popups for -fill and -outline layers
      const seenSources = new Set();
      const features = rawFeatures.filter(f => {
        const sourceId = f.layer.source;
        if (seenSources.has(sourceId)) return false;
        seenSources.add(sourceId);
        return true;
      });

      if (!features.length) {
        updateHighlight(map, []);
        return;
      }

      updateHighlight(map, features);

      if (activePopup) activePopup.remove();

      const combinedHTML = features
        .map(f => defaultPopupTemplate(map, f))
        .join('<div class="popup-separator"></div>');

      const newPopup = new mapboxgl.Popup({
        closeButton: true,
        closeOnClick: true,
        offset: 15,
        maxWidth: '300px',
        className: 'modern-click-popup'
      })
        .setLngLat(e.lngLat)
        .setHTML(`<div class="stacked-popups">${combinedHTML}</div>`)
        .addTo(map);

      newPopup.on('close', () => {
        updateHighlight(map, []);
      });

      trackPopup(newPopup);
    });
    map._hasGlobalClickHandler = true;
  }
}