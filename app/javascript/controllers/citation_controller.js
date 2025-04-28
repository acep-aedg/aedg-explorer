// app/javascript/controllers/citation_controller.js
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['output'];

  copy() {
    if (this.hasOutputTarget && this.outputTarget.textContent) {
      navigator.clipboard
        .writeText(this.outputTarget.textContent.trim())
        .catch((err) => {
          console.error('Failed to copy citation:', err);
        });
    }
  }
}
