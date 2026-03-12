import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="sticky-offset"
export default class extends Controller {
  connect() {
    this.updateHeight();
    window.addEventListener("resize", this.updateHeight.bind(this));
  }

  disconnect() {
    window.removeEventListener("resize", this.updateHeight.bind(this));
  }

  updateHeight() {
    const height = this.element.offsetHeight;
    document.documentElement.style.setProperty("--main-toolbar-height", `${height}px`);
  }
}
