import { Controller } from "@hotwired/stimulus"
import DataTable from "datatables.net-bs5";

// Connects to data-controller="datatables"
export default class extends Controller {
  static targets = ["table"];
  static values = {
    order: { type: Array, default: [0, 'asc'] },
    pagesize: { type: Number, default: 10 }
  }

  connect() {
  }

  tableTargetConnected(element) {
    let table = new DataTable(element, {
      retrieve: true,
      order: [this.orderValue],
      pageLength: this.pagesizeValue
    });
  }

  tableTargetDisconnected(element) {
    let table = new DataTable(element, { retrieve: true });
    table.destroy();
  }
}
