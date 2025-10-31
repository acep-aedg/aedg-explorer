import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="summary-frame"
export default class extends Controller {

  static targets = ['frame'];

  changeYear(e) {
    const year = e.target.value
    if (!this.hasFrameTarget) return

    const frame = this.frameTarget
    const src = frame.getAttribute("src")
    if (!src) return

    const url = new URL(src, window.location.origin)
    year ? url.searchParams.set("year", year) : url.searchParams.delete("year")

    frame.setAttribute("src", url.toString())
  }
}
