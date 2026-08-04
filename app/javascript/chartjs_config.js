import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

// --- GLOBAL CHART DEFAULTS ---
// These can be overriden in options: {} in the child controllers renderChart()

if (Chart) {
    // --- VISUALS ---
    Chart.defaults.color = "#404040"; // Match Chartkick default color
    Chart.defaults.font.family = "'Helvetica Neue', 'Arial', sans-serif";
    Chart.defaults.font.size = 14;
    
    // --- BEHAVIOR ---
    Chart.defaults.responsive = true;
    Chart.defaults.maintainAspectRatio = false;
    
    // --- TOOLTIP DEFAULTS ---
    Chart.defaults.plugins.tooltip.bodyFont.size = 14;
    Chart.defaults.plugins.tooltip.titleFont.size = 14;
    
    // --- TITLE DEFAULTS ---
    Chart.defaults.plugins.title.display = true;
    Chart.defaults.plugins.title.align = "center";
    Chart.defaults.plugins.title.font.size = 20;
    Chart.defaults.plugins.title.padding = { bottom: 10 };
    
    // --- SUBTITLE DEFAULTS ---
    Chart.defaults.plugins.subtitle.display = true;
    Chart.defaults.plugins.subtitle.color = "#666",
    Chart.defaults.plugins.subtitle.font.size = 14;
    Chart.defaults.plugins.subtitle.font.style = "italic";
    Chart.defaults.plugins.subtitle.padding = { bottom: 20 };
    
    // --- LEGEND DEFAULTS ---
    Chart.defaults.plugins.legend.display = true;
    Chart.defaults.plugins.legend.position = "bottom";
    Chart.defaults.plugins.legend.align = "center";
    Chart.defaults.plugins.legend.padding = { bottom: 10 };
    Chart.defaults.plugins.legend.title.font = { weight: "bold" };
    Chart.defaults.plugins.legend.title.padding = { top: 20, bottom: 10 };
    Chart.defaults.plugins.legend.title.display = true;
    
    // --- SCALE DEFAULTS ---
    Chart.defaults.scale.title.font = { size: 16 };
    Chart.defaults.scale.title.display = true;
    Chart.defaults.scale.ticks.maxTicksLimit = 10;
    
    // --- LINE CHART DEFAULTS ---
    Chart.defaults.elements.line.tension = 0.3;
    Chart.defaults.elements.line.borderWidth = 2;
    Chart.defaults.elements.point.radius = 2;
}

window.Chart = Chart;

export default Chart;
