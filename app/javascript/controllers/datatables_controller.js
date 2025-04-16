import { Controller } from "@hotwired/stimulus"
import DataTable from "datatables.net-bs5";

// Connects to data-controller="datatables"
export default class extends Controller {
  static targets = ["table"];
  static values = {
    order: { type: Array, default: [0, 'asc'] },
    pagesize: { type: Number, default: 10 },
    load: String
  }

  connect() {
    if (this.hasLoadValue) {
      this.loadData(this.element)
    } else {
      this.initializeDatatable(this.element)
    }
  }

  tableTargetConnected(element) {
    this.initializeDatatable(element)
  }

  tableTargetDisconnected(element) {
    let table = new DataTable(element, { retrieve: true });
    table.destroy();
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
