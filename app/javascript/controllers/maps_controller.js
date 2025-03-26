// app/javascript/controllers/map_controller.js
import { Controller } from '@hotwired/stimulus';

// This controller is used to refresh the map when the tab is shown
// This is useful when the map is hidden and needs to be resized
// Example usage:
// .nav.nav-tabs{ data: { controller: 'maps' } }
//    %li.nav-item{ data: { map_tab: "true" } }

export default class extends Controller {
  
  connect() {
    this.setupRefreshMapTabs();
  }

  setupRefreshMapTabs() {
    this.element
      .querySelectorAll('[data-bs-toggle="tab"][data-map-tab]')
      .forEach((link) => {
        link.addEventListener('shown.bs.tab', () => {
          window.dispatchEvent(new Event('resize'));
        });
      });
  }
}
