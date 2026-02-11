import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="yearly-generation-chart"
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

  renderChart(rawData) {
    const fontColor = "#404040"; // Match Chartkick default color
    const settings = this.responsiveSettings;
    const labels = Object.keys(rawData[0].data);
    const datasets = rawData.map((series) => {
      const baseColor = series.color || "rgba(93, 109, 126, 1)";

      let label = series.name;
      if (label.includes("Electricity used for Energy Storage (MWH)")) {
        label = ["Electricity used for", "Energy Storage (MWH)"];
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
      data: { labels: labels, datasets: datasets },
      options: {
        datasets: {
          line: {
            fill: true,
            tension: 0.3,
            pointRadius: 2,
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
              padding: { bottom: 10 },
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
              display: true,
              text: "Year",
              color: fontColor,
              font: { size: 16 },
            },
          },
          y: {
            stacked: true,
            title: {
              display: true,
              text: "Generation (MWh)",
              color: fontColor,
              font: { size: 16 },
            },
            ticks: {
              maxTicksLimit: 10,
              callback: (value) => {
                return `${new Intl.NumberFormat().format(value)} MWh`;
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
