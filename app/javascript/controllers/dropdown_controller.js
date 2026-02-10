import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ['select'];

  connect() {
    this.selectTarget.selectedIndex = 0;
  }

  update(event) {
    const url = event.target.value;
    Turbo.visit(url);
  }
}
