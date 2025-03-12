import "chart.js";
import { Controller } from "@hotwired/stimulus"

// Basic chart example to get started with Chart.js
// to add in html.haml add this to test 
// %canvas{ data: { controller: "chart" } }

export default class extends Controller {
  static values = { type: String, url: String };

  connect() {
    console.log('Chart Controller Connected!');
    this.fetchChartData();
  }

  async fetchChartData() {
    try {
      const response = await fetch(this.urlValue);
      const data = await response.json();

      this.generateChart(data.labels, data.datasets, data.options);
    } catch (error) {
      console.error("Error fetching chart data:", error);
    }
  }

  generateChart(labels, datasets, options) {
    const ctx = this.element.getContext('2d');

    // Destroy any existing chart instance before creating a new one
    if (this.chart) this.chart.destroy();
    
    this.chart = new Chart(ctx, {
      type: this.typeValue,
      data: {
        labels: labels,
        datasets: datasets,
      },
      options: options,
    });
  }
  
  disconnect() {
    if (this.chart) {
      this.chart.destroy();
    }
  }
}