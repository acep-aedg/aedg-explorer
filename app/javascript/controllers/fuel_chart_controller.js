// controllers/fuel_chart_controller.js
import { Controller } from "@hotwired/stimulus";

// TODO: refactor into using the colors define in charts_helper.rb
const FUEL_COLORS = {
  CL: "#D6D6D6", // light_grey
  DFO: "#f28e2b", // soft_orange
  JF: "#D77A7D", // light_red
  LFG: "#A1866F", // light_brown
  MWH: "#5D6D7E", // medium_grey
  NG: "#8EBFA2", //soft_green
  SUN: "#FDB813", // medium_yellow
  WAT: "#1f77b4", // blue
  WH: "#810000", // dark_red
  WND: "#6BAED6", // light_blue
  WO: "#6E2C00", // dark_brown
};

export default class extends Controller {
  static targets = ["chart"];
  static values = {
    url: String,
    chartType: String,
    options: Object,
    baseTitle: String, // <- pass from view
    baseFilename: String, // <- optional; fallback generated from baseTitle
  };

  connect() {
    this.chart = null;
    this.chartData = null;
    this.chartYear = null;

    this.handleResize = this.debounce(() => {
      if (!this.isHidden()) this.renderChart();
    }, 300);
    window.addEventListener("resize", this.handleResize);

    if (this.isHidden()) {
      this.waitUntilVisible(() => this.renderChart());
    } else {
      this.renderChart();
    }
  }

  disconnect() {
    window.removeEventListener("resize", this.handleResize);
    this.destroyChart();
  }

  // ---------- render & update ----------

  async renderChart() {
    try {
      const res = await fetch(this.urlValue, {
        headers: { Accept: "application/json" },
      });
      const json = await res.json();

      if (Array.isArray(json)) {
        this.chartYear = null;
        this.chartData = json;
      } else {
        this.chartYear = json.year ?? null;
        this.chartData = json.data ?? [];
      }

      this.renderChartData();
    } catch (e) {
      console.error("Failed to fetch chart data:", e);
    }
  }

  renderChartData() {
    if (this.chartTypeValue !== "pie") {
      console.warn(`Unsupported chart type: ${this.chartTypeValue}`);
      return;
    }

    const labels = this.chartData.map((entry) => entry[0]);
    const colors = this.getFuelColors(labels);
    const isXSmall = window.innerWidth < 576;

    const { title, filename } = this._titleAndFilename();

    const chartOptions = {
      ...this.optionsValue,
      title,
      colors,
      download: { filename, ...(this.optionsValue?.download || {}) },
      library: {
        ...(this.optionsValue?.library || {}),
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          ...(this.optionsValue?.library?.plugins || {}),
          legend: {
            ...(this.optionsValue?.library?.plugins?.legend || {}),
            position: isXSmall ? "bottom" : "left",
            align: isXSmall ? "start" : "end",
          },
        },
      },
    };

    // Create or update in place
    const container = this.hasChartTarget ? this.chartTarget : this.element;
    if (this.chart?.updateData) {
      this.chart.updateData(this.chartData, chartOptions);
    } else {
      this.destroyChart();
      this.chart = new Chartkick.PieChart(
        container,
        this.chartData,
        chartOptions,
      );
    }
  }

  changeYear(e) {
    const year = e.target.value;
    const u = new URL(this.urlValue, window.location.origin);
    year ? u.searchParams.set("year", year) : u.searchParams.delete("year");
    this.urlValue = u.toString();

    // Re-fetch with the new year, then update in place
    fetch(this.urlValue, { headers: { Accept: "application/json" } })
      .then((res) => res.json())
      .then((json) => {
        if (Array.isArray(json)) {
          this.chartYear = year || null;
          this.chartData = json;
        } else {
          this.chartYear = json.year ?? year ?? null;
          this.chartData = json.data ?? [];
        }
        this.renderChartData();
      })
      .catch((e) => console.error("Failed to update chart:", e));
  }

  // ---------- helpers ----------

  _titleAndFilename() {
    const baseTitle = this.baseTitleValue || "Chart";
    const baseFile = this.baseFilenameValue || this._param(baseTitle);
    const title = this.chartYear
      ? `${baseTitle} (${this.chartYear})`
      : baseTitle;
    const filename = this.chartYear
      ? `${baseFile}_${this.chartYear}`
      : baseFile;
    return { title, filename };
  }

  getFuelColors(labels) {
    return labels.map((label) => {
      const abbr = Object.keys(FUEL_COLORS).find((code) =>
        label.includes(code),
      );
      return FUEL_COLORS[abbr] || "#ccc";
    });
  }

  destroyChart() {
    if (this.chart && this.chart.destroy) this.chart.destroy();
    this.chart = null;
  }

  isHidden() {
    return this.element.offsetParent === null;
  }

  waitUntilVisible(cb) {
    const obs = new MutationObserver(() => {
      if (!this.isHidden()) {
        obs.disconnect();
        cb();
      }
    });
    obs.observe(document.body, {
      attributes: true,
      subtree: true,
      attributeFilter: ["class"],
    });
  }

  debounce(fn, delay) {
    let t;
    return (...args) => {
      clearTimeout(t);
      t = setTimeout(() => fn.apply(this, args), delay);
    };
  }

  _param(s) {
    return s
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "_")
      .replace(/^_|_$/g, "");
  }
}
