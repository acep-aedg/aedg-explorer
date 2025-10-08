// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "bootstrap";
import 'chartkick';
import 'Chart.bundle';
import DataTable from "datatables.net-bs5";

// --- DataTables reset ---
// Destroy all DataTable instances under the given root
function resetDataTables(root = document) {
  root.querySelectorAll('table.dataTable, table[role="grid"]').forEach((el) => {
    try {
      // Grab existing instance (if any) and destroy it
      const api = new DataTable(el, { retrieve: true }); // get existing instance
      api.destroy(); // cleanly remove DataTable
    } catch (_) {
      // Not initialized; ignore
    }
    // Clear any ad-hoc flags you might have used
    delete el.dataset.dtInitialized;
    if (el._dt) delete el._dt;
  });
}

// --- Maps reset ---
// Destroy all Mapbox maps under the given root
function resetMapboxMaps(root = document) {
  // any element that's a maps controller map target
  root.querySelectorAll('[data-maps-target="map"]').forEach((el) => {
    const map = el._mapbox;
    if (!map) return;
    try {
      map.remove();          // cleanly remove WebGL + handlers + markers/popups
    } catch (_) { /* noop */ }
    el._mapbox = null;       // clear the reference
  });
}

// --- Map toggles reset ---
// also normalize UI so checkboxes don't lie about state
function resetMapToggles(root = document) {
  root
    .querySelectorAll('input.form-check-input[type="checkbox"][data-action*="maps#"]')
    .forEach((cb) => { cb.checked = false; });
}

// Clean before Turbo swaps in new DOM
document.addEventListener("turbo:before-render", () => {
  resetDataTables(document);
  resetMapboxMaps(document);
  resetMapToggles(document);
});

// Clean before Turbo caches current page
document.addEventListener("turbo:before-cache", () => {
  resetDataTables(document);
  resetMapboxMaps(document);
  resetMapToggles(document); 
})

// Clean before a Turbo Frame is swapped
document.addEventListener("turbo:before-frame-render", (ev) => {
  resetDataTables(ev.target);
  resetMapboxMaps(ev.target);
  resetMapToggles(ev.target); 
});
