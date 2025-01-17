import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="community-dropdown"
export default class extends Controller {
  static targets = ['select'];

  connect() {
    console.log('community_dropdown_controller connected to', this.element);
    this.syncDropdownWithUrl();
  }

  update(event) {
    const friendlyId = event.target.value;
    console.log(friendlyId);

    if (friendlyId) {
      const url = `/communities/${friendlyId}`;
      console.log(`Navigating to: ${url}`);
      Turbo.visit(url); // Navigate to the selected community
    }
  }

  syncDropdownWithUrl() {
    // Extract the friendly ID from the current URL path
    const pathParts = window.location.pathname.split('/');
    const selectedCommunity = pathParts[pathParts.length - 1];

    if (selectedCommunity) {
      // Find the matching option in the dropdown
      const matchingOption = Array.from(this.selectTarget.options).find(
        (option) => option.value === selectedCommunity
      );
      if (matchingOption) {
        this.selectTarget.value = selectedCommunity;
      } else {
        this.selectTarget.value = ''; // Reset to default if no match is found
      }
    } else {
      this.selectTarget.value = ''; // Reset to default if no friendly ID is in the URL
    }
  }
}
