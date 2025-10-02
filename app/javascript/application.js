// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "bootstrap";
import 'chartkick';
import 'Chart.bundle';

// app/javascript/application.js
import DataTable from "datatables.net-bs5";

// ONE function to clean up any DataTables under a root node
function resetDataTables(root = document) {
  root.querySelectorAll('table.dataTable, table[role="grid"]').forEach((el) => {
    try {
      // Grab existing instance (if any) and destroy it
      const api = new DataTable(el, { retrieve: true });
      api.destroy();
    } catch (_) {
      // Not initialized; ignore
    }
    // Clear any ad-hoc flags you might have used
    delete el.dataset.dtInitialized;
    if (el._dt) delete el._dt;
  });
}

// Hook it into Turbo lifecycle (minimal glue)
document.addEventListener("turbo:before-render", () => resetDataTables(document));
document.addEventListener("turbo:before-cache",  () => resetDataTables(document));
// If you use Turbo Frames, also clean just the frame being swapped:
document.addEventListener("turbo:before-frame-render", (ev) => resetDataTables(ev.target));
