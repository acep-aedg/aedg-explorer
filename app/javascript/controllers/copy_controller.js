import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="copy"
export default class extends Controller {
  static targets = ['source', 'button', 'icon', 'label'];

  copy() {
    if (!this.hasSourceTarget) return;

    const text = this.sourceTarget.textContent.trim();

    navigator.clipboard
      .writeText(text)
      .then(() => this.showCopiedState())
      .catch((err) => {
        console.error('Failed to copy:', err);
      });
  }

  showCopiedState() {
    if (this.hasButtonTarget && this.hasIconTarget && this.hasLabelTarget) {
      this.buttonTarget.classList.replace(
        'btn-outline-secondary',
        'btn-success'
      );
      this.iconTarget.classList.replace('bi-clipboard', 'bi-clipboard-check');
      this.labelTarget.textContent = 'Copied';

      setTimeout(() => {
        this.buttonTarget.classList.replace(
          'btn-success',
          'btn-outline-secondary'
        );
        this.iconTarget.classList.replace('bi-clipboard-check', 'bi-clipboard');
        this.labelTarget.textContent = 'Copy';
      }, 3000);
    }
  }
}
