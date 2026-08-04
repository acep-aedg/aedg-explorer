import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { url: String, title: String };

  async urlValueChanged() {
      if (!this.urlValue) return;

      try {
        const response = await fetch(this.urlValue);
        if (!response.ok) throw new Error("Network response was not ok");
        const rawData = await response.json();
        const chartData = this.prepareData(rawData);
        this.renderChart(chartData);
      } catch (error) {
        console.error("Chart load failed:", error);
      }
    }

    // Child controllers can override this to transform data
    prepareData(rawData) {
      return rawData;
    }

    // Child controllers should override this to render the chart
    renderChart(chartData) {}

  get responsiveSettings() {
    const isLarge = window.innerWidth >= 1024;
    return {
      legendPosition: isLarge ? "right" : "bottom",
      legendTitle: isLarge
        ? ["Click on a source", "to hide/show"]
        : "Click on a source to hide/show",
    };
  }

  handleResize(chart) {
    const updated_settings = this.responsiveSettings;

    if (
      chart.options.plugins.legend.position !== updated_settings.legendPosition
    ) {
      chart.options.plugins.legend.position = updated_settings.legendPosition;
      chart.options.plugins.legend.title.text = updated_settings.legendTitle;
      chart.update();
    }
  }

  disconnect() {
    if (this.chart) this.chart.destroy();
  }
}
