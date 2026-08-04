import ChartBaseController from "./chart_base_controller";

// Connects to data-controller="yearly-electric-rates-chart"
export default class extends ChartBaseController {
  renderChart(chartData) {
    const settings = this.responsiveSettings;

    this.chart = new Chart(this.element, {
      type: "line",
      data: chartData,
      options: {
        plugins: {
          title: {
            text: this.titleValue,
          },
          legend: {
            maxWidth: settings.legendMaxWidth,
            position: settings.legendPosition,
            title: {
              text: settings.legendTitle,
            },
            labels: {
              textAlign: "left",
              padding: 10,
              generateLabels: (chart) => {
                const originalLabels = chart.constructor.defaults.plugins.legend.labels.generateLabels(chart);
                const isSidebar = chart.options.plugins.legend.position === "right";

                return originalLabels.map((label) => {
                  if (isSidebar && label.text.includes(" - ")) {
                    label.text = label.text
                      .split(" - ")
                      .map((str) => str.trim());
                  }
                  return label;
                });
              },
            },
          },
          tooltip: {
            mode: "index",
            intersect: false,
            usePointStyle: true,
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
              text: "Year",
            },
          },
          y: {
            beginAtZero: true,
            title: {
              text: "Revenue per kWh",
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
        onResize: (chart) => this.handleResize(chart),
      },
    });
  }
}
