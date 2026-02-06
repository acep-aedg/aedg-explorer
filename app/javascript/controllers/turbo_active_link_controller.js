import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="turbo-active-link"
export default class extends Controller {
  static targets = ["link"];
  static classes = ["active"];

  connect() {
    this.updateActiveState();
    document.addEventListener("turbo:render", () => this.updateActiveState());
  }

  updateActiveState() {
    const currentPath = window.location.pathname;

    this.linkTargets.forEach((link) => {
      const isActive = link.pathname === currentPath;

      if (isActive) {
        link.classList.add(...this._activeClasses);
      } else {
        link.classList.remove(...this._activeClasses);
      }
    });
  }

  get _activeClasses() {
    return this.activeClasses.length === 0 ? ["active"] : this.activeClasses;
  }
}
