import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]
  static values = {
    /* Configuration for the charts to be updated.
      Expects an Array of Objects. Example:
      [
        {
          id: "generation-monthly",                                    // REQUIRED: DOM ID of the chart
          url: "generation_monthly_community_charts_path(@community)", // REQUIRED: Data URL
          param: "year",                                               // REQUIRED: The query param to update, defaults to 'year'
          baseTitle: "Monthly Generation"                              // OPTIONAL: Title prefix
        }
      ]
    */
    charts: { type: Array, default: [] }
  }

  update(event) {
    const value = event.target.value

    // 1. Update Frames
    // Checks for data-param="year" on the frame, or defaults to "year"
    if (this.frameTargets.length > 0) {
      this.frameTargets.forEach(frame => {
        const param = frame.dataset.param || 'year'
        this._updateFrameUrl(frame, value, param)
      })
    }

    // 2. Update Charts
    this.chartsValue.forEach(config => {
      const paramName = config.param || 'year'
      this._updateChart(config, value, paramName)
    })
  }

  // --- Helpers ---

  _updateChart(config, value, param) {
    const { id, url, baseTitle } = config 
    
    // Safety check for Chartkick
    const chartLib = window.Chartkick || Chartkick
    if (!chartLib) return

    const chart = chartLib.charts[id]
    
    if (chart) {
      if (baseTitle) {
        chart.options.title = value ? `${baseTitle} (${value})` : baseTitle
      }

      if (url) {
        const newUrl = this._buildUrl(url, value, param)
        chart.updateData(newUrl)
      }
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