import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // We use 'targets' so we can update multiple frames at once
  static targets = ["frame"]
  static values = {
    paramName: { type: String, default: "year" }
  }

  update(event) {
    const value = event.target.value
    const param = this.paramNameValue

    // Loop through every targeted frame and update its URL
    this.frameTargets.forEach(frame => {
      this._updateFrameUrl(frame, value, param)
    })
  }

  _updateFrameUrl(frame, value, param) {
    const currentSrc = frame.getAttribute("src")
    if (currentSrc) {
      const url = new URL(currentSrc, window.location.origin)
      // Update or delete the query parameter
      value ? url.searchParams.set(param, value) : url.searchParams.delete(param)
      frame.setAttribute("src", url.toString())
    }
  }
}