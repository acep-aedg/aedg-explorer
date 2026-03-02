import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
import {
  BarWithErrorBarsController,
  BarWithErrorBar,
} from "chartjs-chart-error-bars";

Chart.register(...registerables, BarWithErrorBarsController, BarWithErrorBar);

// Connects to data-controller="sex-distribution-chart"
export default class extends Controller {
  static targets = ["canvas"];
  static values = {
    url: String,
    title: String,
    femaleBarColor: String,
    maleBarColor: String,
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

  prepareChartData(rawData) {
    return {
      labels: rawData.map((d) => d.period),
      datasets: [
        {
          label: "Male",
          backgroundColor: this.maleBarColor || "#1f77b4",
          data: rawData.map((d) => ({
            y: d.male_estimate,
            yMin: Math.max(0, d.male_estimate - d.male_moe),
            yMax: d.male_estimate + d.male_moe,
          })),
        },
        {
          label: "Female",
          backgroundColor: this.femaleBarColor || "#ff7f0e",
          data: rawData.map((d) => ({
            y: d.female_estimate,
            yMin: Math.max(0, d.female_estimate - d.female_moe),
            yMax: d.female_estimate + d.female_moe,
          })),
        },
      ],
    };
  }

  renderChart(rawData) {
    if (this.chart) this.chart.destroy();
    const allValues = rawData.flatMap((d) => [
      (d.male_estimate || 0) + (d.male_moe || 0),
      (d.female_estimate || 0) + (d.female_moe || 0),
    ]);
    const maxWhisker = Math.max(...allValues, 0);
    const chartData = this.prepareChartData(rawData);
    const fontColor = "#404040";

    this.chart = new Chart(this.canvasTarget, {
      type: BarWithErrorBarsController.id,
      data: chartData,
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
            mode: "index",
            callbacks: {
              title: (context) => {
                return "Estimated Population";
              },
              label: (context) => {
                const v = context.raw;
                const moe = Math.round(v.yMax - v.y);
                const label = context.dataset.label;
                return `${label}: ${context.formattedValue} (±${moe})`;
              },
            },
          },
        },
        scales: {
          y: {
            beginAtZero: true,
            suggestedMax: maxWhisker * 1.15,
            title: { display: true, text: "Population Count" },
          },
          x: { title: { display: true, text: "Survey Period" } },
        },
      },
    });
  }

  disconnect() {
    if (this.chart) this.chart.destroy();
  }
}
