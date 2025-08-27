import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._onShown = (e) => {
      const tab = e.target; 
      const detail = {
        url: tab.dataset.layerUrl,
        color: tab.dataset.color,
        outlineColor: tab.dataset.outlineColor,
      };
      window.dispatchEvent(new CustomEvent("maps:select-layer", { detail }));
    };

    this.element.addEventListener("shown.bs.tab", this._onShown);
  }

  disconnect() {
    this.element.removeEventListener("shown.bs.tab", this._onShown);
  }
}