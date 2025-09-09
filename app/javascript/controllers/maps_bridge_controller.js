import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger"];
  static values = {
    defaultLayerUrl: String,
    defaultColor: String,
    defaultOutlineColor: String,
    rootId: String,
  };

  connect() {
    this._manualUntil = 0;

    // Single delegated click handler for any child with data-layer-url
    this._onClick = (e) => {
      const el = e.target.closest("[data-layer-url]");
      if (!el || !this.element.contains(el)) return;

      const detail = {
        url: el.dataset.layerUrl,
        color: el.dataset.color,
        outlineColor: el.dataset.outlineColor,
        clear: true,
      };
      if (!detail.url) return;

      this._manualUntil = Date.now() + 2000;
      window.dispatchEvent(new CustomEvent("maps:select-layer", { detail }));
    };

    this.element.addEventListener("click", this._onClick);

    // --- Observe the header to auto-select default once
    if (this.hasTriggerTarget && this.hasDefaultLayerUrlValue) {
      const root = this.rootIdValue ? document.getElementById(this.rootIdValue) : null;
      this._seen = false;
      this._io = new IntersectionObserver(
        (entries) => {
          const entry = entries[0];
          if (!entry.isIntersecting) return;
          if (Date.now() < this._manualUntil) return;
          if (this._seen) return;

          this._seen = true;
          const detail = {
            url: this.defaultLayerUrlValue,
            color: this.defaultColorValue,
            outlineColor: this.defaultOutlineColorValue,
            clear: true,
          };
          window.dispatchEvent(new CustomEvent("maps:select-layer", { detail }));
        },
        { root, threshold: 0.5 }
      );
      this._io.observe(this.triggerTarget);
    }
  }

  disconnect() {
    this.element.removeEventListener("click", this._onClick);
    this._io?.disconnect();
  }
}
