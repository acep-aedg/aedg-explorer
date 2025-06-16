// Stimulus controller for rendering fuel-type charts with consistent colors.
//
// Features:
// - Fetches chart data from a provided URL.
// - Uses Chartkick to render a pie chart.
// - Assigns consistent colors based on fuel type codes.
// - Merges options with Gloabl Chartkick Options located in (config/initializers/chartkick.rb)
//
// Requirements:
// - Chart type must be "pie" (only pie charts are currently supported).
// - Each data label must include a fuel code abbreviation in parentheses,
//   e.g., "Natural Gas (NG)".
//
// Connects to: data-controller="fuel-chart"

import { Controller } from '@hotwired/stimulus';

const FUEL_COLORS = {
  SUN: '#FDB813',
  LFG: '#8E44AD',
  MWH: '#1ABC9C',
  WC: '#7F8C8D',
  SUB: '#34495E',
  WAT: '#3498DB',
  DFO: '#E67E22',
  LIG: '#A0522D',
  NG: '#2ECC71',
  WND: '#95A5A6',
  JF: '#D35400',
  WO: '#6E2C00',
};

export default class extends Controller {
  static values = {
    url: String,
    chartType: String,
    options: Object,
  };

  connect() {
    fetch(this.urlValue)
      .then((res) => res.json())
      .then((data) => {
        const labels = data.map((entry) => entry[0]);
        const colors = labels.map((label) => {
          const abbrMatch = label.match(/\(([^)]+)\)$/); // extract abbreviation in parentheses
          const abbr = abbrMatch ? abbrMatch[1] : null;
          return FUEL_COLORS[abbr] || '#ccc';
        });

        const chartOptions = {
          ...this.optionsValue,
          colors: colors,
        };

        if (this.chartTypeValue === 'pie') {
          new Chartkick.PieChart(this.element, data, chartOptions);
        }
      });
  }
}
