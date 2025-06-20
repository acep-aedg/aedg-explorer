// Stimulus controller for rendering fuel-type charts using Chartkick + Chart.js.
//
// Features:
// - Fetches and caches chart data from a provided URL.
// - Renders responsive pie charts with consistent colors based on fuel type codes.
// - Dynamically updates chart layout for small screens (legend position).
// - Destroys any existing chart instance before re-rendering.
// - Waits for chart container to become visible before rendering (for tabbed/hidden UIs).
// - Redraws chart on window resize (debounced).
// - Warns if chart type is unsupported or data is invalid.
//
// Requirements:
// - Chart type must be "pie".
// - Chart labels must include a fuel code within the label. e.g., "Natural Gas (NG)", "NG - Natural Gas", "Diesel DFO", "DFO"
//
// Connects to: data-controller="fuel-chart"

import { Controller } from '@hotwired/stimulus';

const FUEL_COLORS = {
  CL: '#F1C40F', // Coal (All coal types combined)
  DFO: '#E67E22', // Distillate Fuel Oil,
  JF: '#D35400', // Jet Fuel
  LFG: '#A1866F', // Landfill Gas
  LIG: '#A0522D', // Lignite Coal
  MWH: '#5D6D7E', // Electricity used for Energy Storage
  NG: '#8EBFA2', // Natural Gas
  SUB: '#34495E', // Subbituminous coal
  SUN: '#FDB813', // Solar
  WAT: '#3498DB', // Water at Hydroelectric Turbine
  WC: '#4B4B4B', // Waste Coal
  WH: '#B7410E', // Waste Heat
  WND: '#2980B9', // Wind
  WO: '#6E2C00', // Waste Oil
};

export default class extends Controller {
  static values = {
    url: String,
    chartType: String,
    options: Object,
  };

  connect() {
    this.chart = null;
    this.chartData = null;
    this.handleResize = this.debounce(() => {
      if (!this.isHidden()) this.renderChart();
    }, 300);

    window.addEventListener('resize', this.handleResize);

    if (this.isHidden()) {
      this.waitUntilVisible(() => this.renderChart());
    } else {
      this.renderChart();
    }
  }

  disconnect() {
    window.removeEventListener('resize', this.handleResize);
    this.destroyChart();
  }

  isHidden() {
    return this.element.offsetParent === null;
  }

  waitUntilVisible(callback) {
    const observer = new MutationObserver(() => {
      if (!this.isHidden()) {
        observer.disconnect();
        callback();
      }
    });

    observer.observe(document.body, {
      attributes: true,
      subtree: true,
      attributeFilter: ['class'],
    });
  }

  destroyChart() {
    if (this.chart && this.chart.destroy) {
      this.chart.destroy();
    }
    this.chart = null;
  }

  renderChart() {
    if (!this.chartData) {
      fetch(this.urlValue)
        .then((res) => res.json())
        .then((data) => {
          this.chartData = data;
          this.renderChartData();
        })
        .catch((error) => {
          console.error('Failed to fetch chart data:', error);
        });
    } else {
      this.renderChartData();
    }
  }

  renderChartData() {
    if (this.chartTypeValue !== 'pie') {
      console.warn(`Unsupported chart type: ${this.chartTypeValue}`);
      return;
    }
    
    this.destroyChart();

    const labels = this.chartData.map((entry) => entry[0]);
    const colors = this.getFuelColors(labels);
    const isXSmallScreen = window.innerWidth < 576;

    const chartOptions = {
      ...this.optionsValue,
      colors: colors,
      library: {
        ...(this.optionsValue?.library || {}),
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          ...(this.optionsValue?.library?.plugins || {}),
          legend: {
            position: isXSmallScreen ? 'bottom' : 'left',
            align: isXSmallScreen ? 'start' : 'end',
          },
        },
      },
    };

    this.chart = new Chartkick.PieChart(
      this.element,
      this.chartData,
      chartOptions
    );
  }

  getFuelColors(labels) {
    return labels.map((label) => {
      const abbr = Object.keys(FUEL_COLORS).find(code =>
        label.includes(code)
      );
      return FUEL_COLORS[abbr] || '#ccc';
    });
  }

  debounce(callback, delay) {
    let timeout;
    return (...args) => {
      clearTimeout(timeout);
      timeout = setTimeout(() => callback.apply(this, args), delay);
    };
  }
}
