import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger"];
  static values = {
    defaultLayerUrl: String,
    defaultColor: String,
    defaultOutlineColor: String,
    rootId: String, // optional: id of a scrollable container
  };

  connect() {
    // --- Bootstrap tabs → still dispatch maps:select-layer on shown
    this._manualUntil = 0;
    this._onShown = (e) => {
      const tab = e.target;
      const detail = {
        url: tab.dataset.layerUrl,
        color: tab.dataset.color,
        outlineColor: tab.dataset.outlineColor,
        clear: true,
      };
      this._manualUntil = Date.now() + 2000; // ignore scroll for 2s after a click
      window.dispatchEvent(new CustomEvent("maps:select-layer", { detail }));
    };
    this.element.addEventListener("shown.bs.tab", this._onShown);

    // --- Observe the "Legislative Districts" header (or any sentinel)
    if (this.hasTriggerTarget && this.hasDefaultLayerUrlValue) {
      const root = this.rootIdValue
        ? document.getElementById(this.rootIdValue)
        : null;

      this._seen = false;
      this._io = new IntersectionObserver(
        (entries) => {
          const entry = entries[0];
          if (!entry.isIntersecting) return;
          if (Date.now() < this._manualUntil) return; // user just clicked a tab
          if (this._seen) return; // only fire once

          this._seen = true;
          const detail = {
            url: this.defaultLayerUrlValue,
            color: this.defaultColorValue,
            outlineColor: this.defaultOutlineColorValue,
            clear: true,
          };
          window.dispatchEvent(new CustomEvent("maps:select-layer", { detail }));
        },
        { root, threshold: 0.5 } // ~half visible
      );

      this._io.observe(this.triggerTarget);
    }
  }

  disconnect() {
    this.element.removeEventListener("shown.bs.tab", this._onShown);
    this._io?.disconnect();
  }
}
