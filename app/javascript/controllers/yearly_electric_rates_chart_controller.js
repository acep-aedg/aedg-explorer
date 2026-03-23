import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="yearly-electric-rates-chart"
export default class extends Controller {
  static values = { url: String, title: String };

  async connect() {
    const response = await fetch(this.urlValue);
    const data = await response.json();
    this.renderChart(data);
  }

  get responsiveSettings() {
    const isLarge = window.innerWidth >= 1024;
    return {
      legendPosition: isLarge ? "right" : "bottom",
      legendTitle: isLarge
        ? ["Click on a source", "to hide/show"]
        : "Click on a source to hide/show",
    };
  }

  renderChart(chartData) {
    const fontColor = "#404040"; // Match Chartkick default color
    const settings = this.responsiveSettings;

    this.chart = new Chart(this.element, {
      type: "line",
      data: chartData,
      options: {
        datasets: {
          line: {
            tension: 0.3,
            pointRadius: 2,
            borderWidth: 2,
          },
        },
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: this.titleValue,
            align: "center",
            color: fontColor,
            font: { size: 20 },
            padding: { bottom: 10 },
          },
          legend: {
            position: settings.legendPosition,
            align: "center",
            reverse: true,
            title: {
              display: true,
              text: settings.legendTitle,
              font: { weight: "bold" },
              padding: { top: 20, bottom: 10 },
            },
          },
          tooltip: {
            mode: "index",
            intersect: false,
            reverse: true,
            callbacks: {
              label: (context) => {
                return `${context.dataset.label}: $${context.formattedValue}/kWh`;
              },
            },
          },
        },
        scales: {
          x: {
            title: {
              display: true,
              text: "Year",
              color: fontColor,
              font: { size: 16 },
            },
          },
          y: {
            title: {
              display: true,
              text: "Revenue per kWh",
              color: fontColor,
              font: { size: 16 },
            },
            ticks: {
              maxTicksLimit: 10,
              callback: (value) => {
                const formatter = new Intl.NumberFormat("en-US", {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2,
                });
                return `$${formatter.format(value)}`;
              },
            },
          },
        },
        onResize: (chart) => {
          const updated = this.responsiveSettings;
          if (
            chart.options.plugins.legend.position !== updated.legendPosition
          ) {
            chart.options.plugins.legend.position = updated.legendPosition;
            chart.options.plugins.legend.title.text = updated.legendTitle;
            chart.update();
          }
        },
      },
    });
  }

  disconnect() {
    if (this.chart) this.chart.destroy();
  }
}
