import ChartBaseController from "./chart_base_controller";

// Connects to data-controller="electricity-sales-chart"
export default class extends ChartBaseController {
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
                return `${context.dataset.label}: ${context.formattedValue} MWh`;
              },
              footer: (tooltipItems) => {
                let total = 0;
                tooltipItems.forEach((item) => {
                  total += item.parsed.y;
                });
                return `Total: ${new Intl.NumberFormat().format(total)} MWh`;
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
              text: "Electricity Consumed",
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
