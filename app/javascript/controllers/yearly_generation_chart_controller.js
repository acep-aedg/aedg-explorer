import ChartBaseController from "./chart_base_controller";

// Connects to data-controller="yearly-generation-chart"
export default class extends ChartBaseController {
  renderChart(rawData) {
    const settings = this.responsiveSettings;
    const labels = Object.keys(rawData[0].data);
    const datasets = rawData.map((series) => {
      const baseColor = series.color || "rgba(93, 109, 126, 1)";

      let label = series.name;
      if (label.includes("Electricity used for Energy Storage (MWH)")) {
        label = "Energy Storage (MWH)";
      }

      return {
        label: label,
        data: Object.values(series.data),
        borderColor: baseColor,
        backgroundColor: baseColor,
      };
    });

    this.chart = new Chart(this.element, {
      type: "line",
      data: {
        labels: labels,
        datasets: datasets
      },
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
              stacked: true,
              beginAtZero: true,
            title: {
              text: "Generation (MWh)",
            },
            ticks: {
              maxTicksLimit: 10,
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
