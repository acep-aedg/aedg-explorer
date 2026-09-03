import { Controller } from "@hotwired/stimulus";
import { ScrollSpy } from "bootstrap";

export default class extends Controller {
  connect() {
    this.spy = ScrollSpy.getOrCreateInstance(this.element, {
      target: this.element.dataset.bsTarget,
      smoothScroll: true,
      rootMargin: "-20% 0px -50%", // Adjust based on how close sections are to each other
      threshold: [0, 0.1]
    });
  }

  disconnect() {
    if (this.spy) {
      this.spy.dispose();
    }
  }
}
