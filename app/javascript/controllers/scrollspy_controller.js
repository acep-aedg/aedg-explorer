import { Controller } from "@hotwired/stimulus";
import { ScrollSpy } from "bootstrap";

export default class extends Controller {
  connect() {
    this.spy = ScrollSpy.getOrCreateInstance(this.element, {
      target: this.element.dataset.bsTarget,
      smoothScroll: true,
      rootMargin: "-20% 0px -60%", // Adjust based on how close sections are to each other
      threshold: [0.1, 0.5, 1.0], // Adjust based on layout
    });
  }

  refresh() {
    if (this.spy) this.spy.refresh();
  }

  disconnect() {
    if (this.spy) {
      this.spy.dispose();
    }
  }
}
