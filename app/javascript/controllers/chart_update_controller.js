import { Controller } from "@hotwired/stimulus"

// A generic controller for <select> elements that update a Chartkick chart
// by fetching data from a JSON endpoint with a single param (e.g. year, end_year).
export default class extends Controller {
  static values = {
    chartId: String,   // DOM id of the chart container
    baseUrl: String,   // Base JSON endpoint, e.g. /explore/communities/.../charts/gender_distribution
    paramName: String, // Query param name, e.g. "year" or "end_year"
  }

  change(event) {
    const value = event.target.value
    const param = this.paramNameValue || "year"

    const url = this._buildUrl(this.baseUrlValue, param, value)

    const chart = window.Chartkick && window.Chartkick.charts[this.chartIdValue]
    if (chart) {
      chart.updateData(url)
    } else {
      console.warn(`[chart-select] No Chartkick chart found with id=${this.chartIdValue}`)
    }
  }

  _buildUrl(base, param, value) {
    const url = new URL(base, window.location.origin)
    url.searchParams.set(param, value)
    return url.toString()
  }
}