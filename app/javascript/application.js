// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "bootstrap";
import 'chartkick';
import 'Chart.bundle';
import DataTable from "datatables.net-bs5";

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

// Clean DataTables before Turbo swaps in new DOM
document.addEventListener("turbo:before-render", () => resetDataTables(document));
// Clean DataTables before Turbo caches current page
document.addEventListener("turbo:before-cache",  () => resetDataTables(document));
// Clean DataTables before a Turbo Frame is swapped
document.addEventListener("turbo:before-frame-render", (ev) => resetDataTables(ev.target));
