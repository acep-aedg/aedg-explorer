import "chart.js";
import { Controller } from "@hotwired/stimulus"

// THIS IS A GUIDE: Basic chart example to get started with Chart.js
// to add in html.haml add this to test 
// %canvas{ data: { controller: "chart" } }


export default class extends Controller {
  static targets = ["barChart", "pieChart", "bubbleChart"];

  connect() {
    this.charts = {};  // Store chart instances
    this.loadChartData();
  }

  loadChartData = async () => { // ✅ Arrow function to keep "this" context
    try {
      const response = await fetch("/communities/chart_data");
      const json = await response.json();

      console.log("Chart Data:", json);

      this.renderBarChart(["Total Communities"], [json.total_communities]);
      this.renderPieChart(json.pce_labels, json.pce_data);
      this.renderBubbleChart(json.bubble_data);
    } catch (error) {
      console.error("Error loading chart data:", error);
    }
  }

renderBarChart = (labels, data) => {
  if (!this.hasBarChartTarget) return;
  const ctx = this.barChartTarget.getContext("2d");

  if (this.charts.barChart) {
    this.charts.barChart.destroy();
  }


  this.charts.barChart = new Chart(ctx, {
    type: "bar",
    data: {
      labels: labels,
      datasets: [{
        label: "Total Communities",
        data: data,
        backgroundColor: "rgba(54, 162, 235, 0.6)",
        borderWidth: 1,
      }]
    },
    options: {
      responsive: true, // ✅ Prevents auto-resizing
      maintainAspectRatio: false, // ✅ Allows manual control
      layout: {
        padding: 10 // ✅ Adds spacing around chart
      },
      scales: {
        y: { beginAtZero: true }
      }
    }
  });
}


  renderPieChart = (labels, data) => {
    if (!this.hasPieChartTarget) return;
    const ctx = this.pieChartTarget.getContext("2d");
  
    if (this.charts.pieChart) {
      this.charts.pieChart.destroy();
    }
  
    this.charts.pieChart = new Chart(ctx, {
      type: "pie",
      data: {
        labels: labels,
        datasets: [{
          data: data,
          backgroundColor: ["rgba(75, 192, 192, 0.6)", "rgba(143, 255, 99, 0.6)"]
        }]
      },
      options: {
        responsive: false, // Prevent automatic resizing
        maintainAspectRatio: false, // Allow us to manually control size
        layout: {
          padding: 10 // Adds spacing so labels don’t get cut off
        }
      }
    });
  }
  
  renderBubbleChart = (data) => {
    if (!this.hasBubbleChartTarget) return;
    const ctx = this.bubbleChartTarget.getContext("2d");
  
    if (this.charts.bubbleChart) {
      this.charts.bubbleChart.destroy();
    }
  
    // ✅ Generate color array separately
    const bubbleData = data.map((community) => ({
      label: community.name,
      x: community.x,
      y: community.y,
      r: community.pce_eligible ? 15 : 7, // 🎯 Adjust size dynamically
    }));
  
    const bubbleColors = data.map((community) =>
      community.pce_eligible ? "rgba(0, 255, 0, 0.6)" : "rgba(255, 99, 132, 0.6)"
    );
  
    this.charts.bubbleChart = new Chart(ctx, {
      type: "bubble",
      data: {
        datasets: [{
          label: "Communities",
          data: bubbleData, // 🎯 Bubble Data
          backgroundColor: bubbleColors, // 🎯 Apply colors to each bubble
          borderColor: bubbleColors, // 🎯 Match border to background
          borderWidth: 1,
        }]
      },
      options: {
        responsive: true,
        plugins: {
          tooltip: {
            callbacks: {
              label: function(context) {
                const dataPoint = context.raw;
                return `${dataPoint.label}: (${dataPoint.x}, ${dataPoint.y})`;
              }
            }
          }
        },
        scales: {
          x: { title: { display: true, text: "Longitude" } },
          y: { title: { display: true, text: "Latitude" } }
        }
      }
    });
  }
}  