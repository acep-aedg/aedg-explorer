import "chart.js";
import { Controller } from "@hotwired/stimulus"

// Basic chart example to get started with Chart.js
// to add in html.haml add this to test 
// %canvas{ data: { controller: "chart" } }

export default class extends Controller {
  connect() {
    console.log("Chart Controller Connected!");

    const ctx = this.element.getContext("2d");

    new Chart(ctx, {  // ✅ Correct usage
      type: "bar",
      data: {
        labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
        datasets: [{
          label: "Votes",
          data: [12, 19, 3, 5, 2, 3],
          borderWidth: 1,
        }]
      },
      options: {
        responsive: true,
        scales: {
          y: { beginAtZero: true }
        }
      }
    });
  }
}