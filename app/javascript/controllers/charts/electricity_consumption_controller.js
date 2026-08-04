import BaseController from "./base_controller";

// Connects to data-controller="charts--electricity-consumption"
export default class extends BaseController {
  renderChart(chartData) {
    const settings = this.responsiveSettings;

    this.chart = new Chart(this.element, {
      type: "line",
      data: chartData,
      options: {
        datasets: {
          line: {
            fill: true,
          },
        },
        plugins: {
          title: {
            text: this.titleValue,
          },
          legend: {
            position: settings.legendPosition,
            reverse: true,
            title: {
              text: settings.legendTitle,
            },
          },
          tooltip: {
            mode: "index",
            intersect: false,
            reverse: true,
            callbacks: {
              label: (context) => {
                return `${context.dataset.label}: ${context.formattedValue} MWh/Customer`;
              },
            },
          },
        },
        scales: {
          x: {
            stacked: true,
            title: {
              text: "Year",
            },
          },
          y: {
            beginAtZero: true,
            stacked: true,
            title: {
              text: "Electricity Consumed Per Customer",
            },
            ticks: {
              callback: (value) => {
                return `${new Intl.NumberFormat().format(value)} MWh`;
              },
            },
          },
        },
        onResize: (chart) => this.handleResize(chart),
      },
    });
  }
}
