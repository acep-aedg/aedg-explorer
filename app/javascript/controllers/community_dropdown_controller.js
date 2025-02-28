import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="community-dropdown"
export default class extends Controller {
  static targets = ['select'];

  connect() {
    this.syncDropdownWithUrl();
  }

  update(event) {
    const url = event.target.value;
    Turbo.visit(url);
  }

  syncDropdownWithUrl() {
    const currentPath = window.location.pathname;

    // Find the matching option with a value equal to the current path
    const matchingOption = Array.from(this.selectTarget.options).find(
      (option) => option.value === currentPath
    );

    if (matchingOption) {
      this.selectTarget.value = currentPath;
    } else {
      this.selectTarget.value = '';
    }
  }
}
