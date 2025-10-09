export const SELECT_LAYER_EVENT = 'maps:select-layer';

let globalHandler = null;

// Delegated click so buttons can be anywhere.
// Filters by optional data-map-id to support multiple maps.
export function installGlobalLayerClick(mapId) {
  if (globalHandler) return;
  globalHandler = (e) => {
    const el = e.target.closest('[data-map-layer-url],[data-layer-url],[data-url]');
    if (!el) return;

    const targetMapId = el.dataset.mapId;
    if (targetMapId && mapId && targetMapId !== mapId) return;

    const url = el.dataset.mapLayerUrl || el.dataset.layerUrl || el.dataset.url;
    if (!url) return;

    const detail = {
      url,
      color: el.dataset.color,
      outlineColor: el.dataset.outlineColor || el.dataset['outline-color'],
      clear: el.dataset.clear ? el.dataset.clear !== 'false' : true,
      fit: el.dataset.fit ? el.dataset.fit !== 'false' : true,
    };
    window.dispatchEvent(new CustomEvent(SELECT_LAYER_EVENT, { detail }));
  };
  window.addEventListener('click', globalHandler, true);
}

export function removeGlobalLayerClick() {
  if (!globalHandler) return;
  window.removeEventListener('click', globalHandler, true);
  globalHandler = null;
}
