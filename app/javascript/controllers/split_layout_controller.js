import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="split-layout"
export default class extends Controller {
  static targets = ["left", "right", "gutter"]

  connect() {
    this.isResizing = false

    this.startResize = this.startResize.bind(this)
    this.resize = this.resize.bind(this)
    this.stopResize = this.stopResize.bind(this)

    // Listen for when the user clicks down on the gutter
    this.gutterTarget.addEventListener("mousedown", this.startResize)

    // Listen for mouse movement and mouse release across the whole document
    // (This ensures smooth dragging even if the mouse moves off the gutter)
    document.addEventListener("mousemove", this.resize)
    document.addEventListener("mouseup", this.stopResize)
  }

  disconnect() {
    // Clean up our event listeners if the user navigates away
    this.gutterTarget.removeEventListener("mousedown", this.startResize)
    document.removeEventListener("mousemove", this.resize)
    document.removeEventListener("mouseup", this.stopResize)
  }

  startResize(e) {
    this.isResizing = true
    // Prevent text highlighting while dragging
    document.body.style.userSelect = "none"
    document.body.style.cursor = "col-resize"
  }

  resize(e) {
      if (!this.isResizing) return

      const containerRect = this.element.getBoundingClientRect()
      const newWidthPercentage = ((e.clientX - containerRect.left) / containerRect.width) * 100

      // Set your minimum and maximum widths for the LEFT side (the map) here!
      const minLeftPercentage = 0
      const maxLeftPercentage = 70

      if (newWidthPercentage > minLeftPercentage && newWidthPercentage < maxLeftPercentage) {
        // We subtract 5px here to account for half of our 10px gutter
        this.leftTarget.style.width = `calc(${newWidthPercentage}% - 5px)`
        this.rightTarget.style.width = `calc(${100 - newWidthPercentage}% - 5px)`

        // Force Mapbox to redraw
        window.dispatchEvent(new Event('resize'))
      }
    }

  stopResize() {
    this.isResizing = false
    // Restore normal text selection and cursor
    document.body.style.userSelect = ""
    document.body.style.cursor = ""
  }
}
