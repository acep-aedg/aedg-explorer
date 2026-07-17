import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  connect() {
    // Catch direct links on page load (e.g., someone shares a link with #electric-rates)
    this.scrollToHash()
  }

  // Fired automatically by turbo:frame-render when switching main tabs
  scrollToTop(event) {
    // Only force scroll to top if the URL doesn't have a jump link hash
    if (!window.location.hash) {
      this.element.scrollTo({ top: 0, behavior: "smooth" })
    } else {
      this.scrollToHash()
    }
  }

  // Fired when clicking a pill in the Jump Nav
  jump(event) {
    event.preventDefault() // Stop the browser from doing its jerky native jump

    // Grab the "#something" from the link's href
    const href = event.currentTarget.getAttribute("href")
    const targetId = href.substring(1)
    const targetElement = document.getElementById(targetId)

    if (targetElement) {
      // Update the URL in the browser silently
      history.pushState(null, null, href)
      // Smoothly scroll our .split-right container to the element
      targetElement.scrollIntoView({ behavior: "smooth", block: "start" })
    }
  }

  // Helper method
  scrollToHash() {
    if (window.location.hash) {
      const targetId = window.location.hash.substring(1)
      const targetElement = document.getElementById(targetId)
      if (targetElement) {
        targetElement.scrollIntoView({ behavior: "smooth", block: "start" })
      }
    }
  }
}
