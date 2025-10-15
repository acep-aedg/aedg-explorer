import { Controller } from "@hotwired/stimulus"
import DataTable from "datatables.net-bs5";

// Connects to data-controller="datatables"
export default class extends Controller {
  static values = {
    order: { type: Array, default: [0, 'asc'] },
    pagesize: { type: Number, default: 10 },
    load: String
  }

  connect() {
    let table = this.element.querySelector("table");
    if (this.hasLoadValue) {
      this.loadData(table)  
    } else {
      this.initializeDatatable(table)
    }
  }

  disconnect() {
    let table = this.element.querySelector("table");
    let dt = new DataTable(table, { retrieve: true });
    dt.destroy();
  }

  loadData(element) {
    fetch(this.loadValue)
      .then(response => response.json())
      .then(json => this.initializeDatatable(element, json.data, json.columns))
  }

  initializeDatatable(element, data, columns) {
    new DataTable(element, {
      retrieve: true,
      data: data,
      columns: columns,
      order: [this.orderValue],
      pageLength: this.pagesizeValue,
      scrollX: true
    });
  }
}
