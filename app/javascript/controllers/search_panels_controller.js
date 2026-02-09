// app/javascript/controllers/search_panels_controller.js

import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"
//  TODO: clean up/ make more turbo or less complex if possible
export default class extends Controller {
    static targets = ["tracker"]

    initialize() {
        this.submitTimeout = null
    }

    connect() {
        // Bind the listener so we can remove it later
        this.externalClickListener = this.closeOnOutsideClick.bind(this)
        window.addEventListener("click", this.externalClickListener)
        
        // Listen for Escape key to close panels
        this.escKeyListener = (e) => { if (e.key === "Escape") this.close() }
        window.addEventListener("keydown", this.escKeyListener)
    }

    disconnect() {
        window.removeEventListener("click", this.externalClickListener)
        window.removeEventListener("keydown", this.escKeyListener)
        if (this.submitTimeout) clearTimeout(this.submitTimeout)
    }

    /**
     * OPTIMISTIC UI: Hides the badge and dims results immediately
     * to make the interface feel faster.
     */
    hideBadge(event) {
        // Visually hide the clicked badge instantly
        const badge = event.currentTarget
        badge.style.display = 'none'
        
        // Dim results to show a "loading" state
        const results = document.getElementById("results_frame")
        if (results) {
            results.style.opacity = '0.5'
            results.style.pointerEvents = 'none'
        }
    }

    /**
     * PANEL TOGGLE: Opens/closes side drawers
     */
    toggle(event) {
        event.preventDefault()
        event.stopPropagation() 
        
        const panelId = event.params.id
        const targetPanel = document.getElementById(panelId)
        if (!targetPanel) return

        // If the clicked panel is already open, just close it
        if (targetPanel.classList.contains('show')) {
            this.close()
            return
        }

        // Otherwise, close others and open this one
        this.closeAll()
        const instance = bootstrap.Collapse.getOrCreateInstance(targetPanel, { toggle: false })
        instance.show()
        
        if (this.hasTrackerTarget) this.trackerTarget.value = panelId
    }

    /**
     * CLOSING LOGIC: Handles "X" button, outside clicks, and nav buttons
     */
    closeOnOutsideClick(event) {
        const openPanel = this.element.querySelector('.collapse.show')
        if (!openPanel) return

        // 1. Did they click an "X" button or the panel's internal close icon?
        const isCloseButton = event.target.closest('.btn-close') || event.target.closest('[data-action*="close"]')

        // 2. Is the click inside the active panel drawer?
        const isInsidePanel = openPanel.contains(event.target)

        // 3. Is the click on a sidebar navigation button?
        const isNavButtonClick = event.target.closest('[data-action*="search-panels#toggle"]')

        // Close if: Clicked the X, or clicked outside (and it wasn't a nav button)
        if (isCloseButton || (!isInsidePanel && !isNavButtonClick)) {
            this.close()
        }
    }

    close() {
        const openPanels = this.element.querySelectorAll('.collapse.show')
        openPanels.forEach(panel => {
            const bsCollapse = bootstrap.Collapse.getInstance(panel)
            if (bsCollapse) {
                bsCollapse.hide()
            } else {
                panel.classList.remove('show')
            }
        })
        
        if (this.hasTrackerTarget) this.trackerTarget.value = ""
    }

    closeAll() {
        const allPanels = this.element.querySelectorAll('.collapse')
        allPanels.forEach(panel => {
            const instance = bootstrap.Collapse.getInstance(panel)
            if (instance) instance.hide()
            panel.classList.remove('show') // Force removal for snappy feel
        })
    }

    /**
     * NO-REFRESH AUTO-SUBMIT:
     * Uses Fetch with a Turbo Stream header to update results + badges
     * without moving the scroll position or reloading the page.
     */
    autoSubmit(event) {
        if (!['INPUT', 'SELECT'].includes(event.target.tagName)) return

        clearTimeout(this.submitTimeout)

        this.submitTimeout = setTimeout(() => {
            const frame = document.getElementById("results_frame")
            
            // If already busy, wait and retry
            if (frame && frame.hasAttribute("busy")) {
                this.autoSubmit(event)
                return
            }

            const form = document.getElementById('filter-form') || event.target.form
            if (!form) return

            // Keep the tracker synced with which panel is open
            const openPanel = this.element.querySelector('.collapse.show')
            if (this.hasTrackerTarget) {
                this.trackerTarget.value = openPanel ? openPanel.id : ""
            }

            // Perform the AJAX request
            const formData = new FormData(form)
            const params = new URLSearchParams(formData)
            const url = `${form.getAttribute('action')}?${params.toString()}`

            fetch(url, {
                headers: { "Accept": "text/vnd.turbo-stream.html" }
            })
            .then(response => response.text())
            .then(html => {
                // Manually tell Turbo to process the stream commands
                Turbo.renderStreamMessage(html)
            })
            .catch(error => console.error("AutoSubmit Error:", error))
        }, 400)
    }
}