import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["source", "button", "icon", "label"];
  static values = { url: String };

  copy(event) {
    if (event) event.preventDefault();

    // Determine what to copy: Priority to URL Value, then Source Target
    let textToCopy = "";
    if (this.hasUrlValue) {
      textToCopy = this.urlValue;
    } else if (this.hasSourceTarget) {
      textToCopy = this.sourceTarget.textContent.trim();
    }

    if (!textToCopy) return;

    navigator.clipboard
      .writeText(textToCopy)
      .then(() => this.showCopiedState())
      .catch((err) => console.error("Failed to copy:", err));
  }

  showCopiedState() {
    // Dynamic Class Swapping, check data attributes on the button target, falling back to defaults
    const btn = this.hasButtonTarget ? this.buttonTarget : this.element;

    const iconOriginal = btn.dataset.copyIconOriginal || "bi-clipboard";
    const iconSuccess = btn.dataset.copyIconSuccess || "bi-clipboard-check";
    const activeClass = btn.dataset.copyActiveClass || "btn-success";
    const originalClass =
      btn.dataset.copyOriginalClass || "btn-outline-secondary";

    // Swap Button Classes
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.replace(originalClass, activeClass);
    }

    // Swap Icons
    if (this.hasIconTarget) {
      this.iconTarget.classList.replace(iconOriginal, iconSuccess);
    }

    // Swap Labels
    const originalLabel = this.hasLabelTarget
      ? this.labelTarget.textContent
      : "Copy";
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = "Copied";
    }

    setTimeout(() => {
      if (this.hasButtonTarget) {
        this.buttonTarget.classList.replace(activeClass, originalClass);
      }
      if (this.hasIconTarget) {
        this.iconTarget.classList.replace(iconSuccess, iconOriginal);
      }
      if (this.hasLabelTarget) {
        this.labelTarget.textContent = originalLabel;
      }
    }, 2000);
  }
}
