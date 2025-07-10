import { Controller } from '@hotwired/stimulus';
import { Tooltip } from 'bootstrap';

// Add the following to your tooltip HTML element (ex. %i, %span, %a, etc.):
// { data: { controller: 'tooltip', bs_toggle: 'tooltip' }, title: 'Add tooltip message here.' }
export default class extends Controller {
  connect() {
    this.tooltip = new Tooltip(this.element);
  }

  disconnect() {
    if (this.tooltip) {
      this.tooltip.dispose();
    }
  }
}
