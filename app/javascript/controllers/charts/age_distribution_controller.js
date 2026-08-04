import BaseController from "./base_controller"
import { Chart, registerables } from "chart.js";
import {
  BarWithErrorBarsController,
  BarWithErrorBar,
} from "chartjs-chart-error-bars";

Chart.register(...registerables, BarWithErrorBarsController, BarWithErrorBar);

// Connects to data-controller="charts--age-distribution"
export default class extends BaseController {
  static targets = ["canvas"];
  static values = {
    url: String,
    baseUrl: String,
    param: { type: String, default: "end_year" },
    title: String,
    baseTitle: String,
    barColor: String,
    errorBarColor: String,
  };

  prepareData(rawData) {
    this.maxWhisker = Math.max(...rawData.map(d => (d.estimate || 0) + (d.moe || 0)), 0);
    return {
      labels: rawData.map((d) => d.label),
      datasets: [
        {
          label: "Estimated Population",
          backgroundColor: this.barColorValue || "#1f77b4",
          errorBarColor: this.errorBarColorValue || "#ff7f0e",
          errorBarWhiskerColor: this.errorBarColorValue || "#ff7f0e",
          errorBarLineWidth: 1,
          errorBarWhiskerLineWidth: 2,
          errorBarWhiskerRatio: 0.3,
          data: rawData.map((d) => ({
            y: d.estimate,
            yMin: Math.max(0, d.estimate - d.moe),
            yMax: d.estimate + d.moe,
          })),
        },
      ],
    };
  }

  renderChart(chartData) {
    if (this.chart) this.chart.destroy();

    this.chart = new Chart(this.canvasTarget, {
      type: BarWithErrorBarsController.id,
      data: chartData,
      options: {
        indexAxis: "x",
        plugins: {
          title: {
            text: this.titleValue,
          },
          subtitle: {
            text: "Whiskers represent the Margin of Error (±)",
          },
          tooltip: {
            callbacks: {
              title: (context) => {
                return `Estimated Population`;
              },
              label: (context) => {
                const v = context.raw;
                const moe = Math.round(v.yMax - v.y);
                const ageGroup = context.label;
                return `${ageGroup} Years: ${context.formattedValue} (±${moe})`;
              },
            },
          },
        },
        scales: {
          y: {
            suggestedMax: this.maxWhisker * 1.15,
            beginAtZero: true,
            title: { display: true, text: "Population Count" },
          },
            x: {
                title: {
                    text: "Age Group"
                }
            },
        },
      },
    });
  }

  update(event) {
    const select = event.target;
    const selectedValue = select.value;
    const selectedLabel = select.options[select.selectedIndex].text;

    this.titleValue = `${this.baseTitleValue} (${selectedLabel})`;

    const newUrl = new URL(this.baseUrlValue, window.location.origin);
    newUrl.searchParams.set(this.paramValue, selectedValue);
    this.urlValue = newUrl.toString();
  }
}
