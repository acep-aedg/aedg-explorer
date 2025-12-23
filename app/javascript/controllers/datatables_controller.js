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
    this.dataTable.destroy();
  }

  loadData(element) {
    fetch(this.loadValue)
      .then(response => response.json())
      .then(json => this.initializeDatatable(element, json.data, json.columns))
  }

  initializeDatatable(element, data, columns) {  
    this.dataTable = new DataTable(element, {
      destroy: true, // overwrite any "Zombie" tables left by Turbo.
      data: data,
      columns: columns,
      order: [this.orderValue],
      pageLength: this.pagesizeValue,
      scrollX: true
    });
  }
}