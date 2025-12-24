import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]
  static values = {
    paramName: { type: String, default: "year" },
    chartId: String,   // ID of the chart DOM element
    chartUrl: String,   // Base URL for the chart JSON data
    baseTitle: String // Chart Title excluding year
  }

  update(event) {
    const value = event.target.value
    const param = this.paramNameValue

    // 1. Update Frames
    this.frameTargets.forEach(frame => {
      this._updateFrameUrl(frame, value, param)
    })

    // 2. Update Chart
    this._updateChart(value, param)
  }

  // --- Helpers ---

  _updateChart(value, param) {
    if (!this.chartIdValue || !this.chartUrlValue) return

    const chart = Chartkick.charts[this.chartIdValue]
    
    if (chart) {
      // 1. Update Title in Options (if base title exists)
      if (this.baseTitleValue) {
        // If value exists: "Title (2023)", else: "Title"
        chart.options.title = value 
          ? `${this.baseTitleValue} (${value})` 
          : this.baseTitleValue
      }

      // 2. Fetch New Data
      const newUrl = this._buildUrl(this.chartUrlValue, value, param)
      chart.updateData(newUrl)
    }
  }

  _updateFrameUrl(frame, value, param) {
    const currentSrc = frame.src
    if (currentSrc) {
      const newUrl = this._buildUrl(currentSrc, value, param)
      frame.src = newUrl
    }
  }

  _buildUrl(baseStr, value, param) {
    const url = new URL(baseStr, window.location.origin)
    value ? url.searchParams.set(param, value) : url.searchParams.delete(param)
    return url.toString()
  }
}