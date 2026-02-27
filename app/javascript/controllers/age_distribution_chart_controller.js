import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
import {
  BarWithErrorBarsController,
  BarWithErrorBar,
} from "chartjs-chart-error-bars";

Chart.register(...registerables, BarWithErrorBarsController, BarWithErrorBar);

export default class extends Controller {
  static targets = ["canvas"];
  static values = {
    url: String,
    baseUrl: String,
    param: { type: String, default: "year" },
    title: String,
    baseTitle: String,
    barColor: String,
    errorBarColor: String,
    
  };

  async urlValueChanged() {
    if (!this.urlValue) return;

    try {
      const response = await fetch(this.urlValue);
      if (!response.ok) throw new Error("Network response was not ok");
      const data = await response.json();
      this.renderChart(data);
    } catch (error) {
      console.error("Chart load failed:", error);
    }
  }

  titleValueChanged() {
    if (this.chart) {
      this.chart.options.plugins.title.text = this.titleValue;
      this.chart.update();
    }
  }

  update(event) {
    const selectedValue = event.target.value;
    this.titleValue = `${this.baseTitleValue} (${selectedValue})`;
    const newUrl = new URL(this.baseUrlValue, window.location.origin);
    newUrl.searchParams.set(this.paramValue, selectedValue);
    this.urlValue = newUrl.toString();
  }

  renderChart(data) {
    if (this.chart) this.chart.destroy();
    const fontColor = "#404040";

    const styledData = {
      ...data,
      datasets: data.datasets.map((dataset) => ({
        ...dataset,
        backgroundColor: this.barColorValue || "1f77b4",
        backgroundColor: this.barColorValue || "1f77b4",
        errorBarColor: this.errorBarColorValue || "ff7f0e",
        errorBarWhiskerColor: this.errorBarColorValue || "ff7f0e",
      })),
    };

    this.chart = new Chart(this.canvasTarget, {
      type: BarWithErrorBarsController.id,
      data: styledData,
      options: {
        indexAxis: "x",
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: this.titleValue,
            font: { size: 18 },
            color: fontColor,
          },
          legend: {
            display: true,
            position: "bottom",
            labels: {
              color: fontColor,
            },
          },
          subtitle: {
            display: true,
            text: "Whiskers represent the Margin of Error (±)",
            color: "#666",
            font: {
              size: 12,
              style: "italic",
            },
            padding: {
              bottom: 10,
            },
          },
          tooltip: {
            callbacks: {
              title: (context) => {
                return `Age Group: ${context[0].label}`;
              },
              label: (context) => {
                const v = context.raw;
                const moe = Math.round(v.yMax - v.y);
                return `Population Estimate: ${v.y} (±${moe})`;
              },
            },
          },
        },
        scales: {
          y: {
            beginAtZero: true,
            title: { display: true, text: "Population Count" },
          },
          x: { title: { display: true, text: "Age Group" } },
        },
      },
    });
  }

  disconnect() {
    if (this.chart) this.chart.destroy();
  }
}
