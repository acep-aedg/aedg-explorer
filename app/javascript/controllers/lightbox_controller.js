import { Controller } from "@hotwired/stimulus"
import GLightbox from "glightbox"

// Connects to data-controller="lightbox"
export default class extends Controller {
  connect() {
    this.lightbox = GLightbox({ selector: '.glightbox' })
  }
}