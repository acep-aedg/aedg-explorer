import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tracker", "form"]

    connect() {
        // Listen for clicks anywhere on the page to handle closing open panels
        this.externalClickListener = this.closeOnOutsideClick.bind(this)
        window.addEventListener("click", this.externalClickListener)
    }

    disconnect() {
        // Clean up the event listener when the controller is destroyed
        window.removeEventListener("click", this.externalClickListener)
    }

    // Handles clicking a sidebar header to show or hide a filter panel
    toggle(event) {
        const id = event.params.id;
        const panel = document.getElementById(id);

        if (panel) {
            const isVisible = panel.classList.contains('panel-visible');

            // Ensure only one panel is open at a time
            this.closeAll();

            // Toggle the target panel based on its previous state
            if (!isVisible) {
                panel.classList.add('panel-visible');
            }

            // Save which panel is now open into the hidden tracker input
            this.updateTracker();
        }
    }

    // Force-opens a specific panel (useful for direct links or initial loads)
    open(event) {
        const panelId = event.params.id;
        const panel = document.getElementById(panelId);
        if (panel) {
            this.closeAll();
            panel.classList.add('panel-visible');
            this.updateTracker();
        }
    }

    // Automatically triggers the search when a checkbox is clicked
    autoSubmit(event) {
        // Find the areas that will be changing
        const resultsFrame = document.getElementById('results_frame')
        const activeFilters = document.getElementById('active_filters_list')

        // Visual feedback: dim the results so the user knows a request is in flight
        if (resultsFrame) resultsFrame.style.opacity = '0.5'
        if (activeFilters) activeFilters.style.opacity = '0.5'

        // Cancel any older requests that haven't finished yet
        if (this.abortController) {
            this.abortController.abort()
        }
        this.abortController = new AbortController()

        this.updateTracker()

        const form = document.getElementById('filter-form')
        if (form) {
            // Send the request immediately
            form.requestSubmit()
        }
    }

    // Add this to your search-panels controller
    autoSubmitSearch(event) {
        // Clear the old timer if the user is still typing
        clearTimeout(this.searchTimeout)

        //  Set a new timer (300ms)
        this.searchTimeout = setTimeout(() => {
            const form = event.target.closest('form')
            const resultsFrame = document.getElementById('results_frame')

            // Visual feedback that it's working
            if (resultsFrame) resultsFrame.style.opacity = '0.5'

            // Submit the form
            form.requestSubmit()
        }, 500)
    }

    // Synchronizes the current UI state with a hidden input field
    // This ensures that when the page updates, your open panel stays open
    updateTracker() {
        if (this.hasTrackerTarget) {
            const openPanel = this.element.querySelector('.panel-visible')
            // Store the open panel's ID so the backend knows which partial to re-render
            this.trackerTarget.value = openPanel ? openPanel.id : ""
        }
    }

    // Helper to remove the 'visible' class from all sidebar panels
    closeAll() {
        this.element.querySelectorAll('.facet-panel').forEach(panel => {
            panel.classList.remove('panel-visible')
        })
    }

    // Detects if the user clicked away from the sidebar to automatically close panels
    closeOnOutsideClick(event) {
        const openPanel = this.element.querySelector('.panel-visible')
        if (!openPanel) return

        // Ignore clicks if they happened inside the panel or on the toggle button itself
        if (openPanel.contains(event.target) || event.target.closest('[data-action*="search-panels#toggle"]')) {
            return
        }

        this.closeAll()
        this.updateTracker()
    }

    // Used by the blue badges to uncheck a specific box remotely
    uncheckSpecific(event) {
        const checkboxId = event.params.id;
        const checkbox = document.getElementById(checkboxId);
        if (checkbox) {
            checkbox.checked = false;
            // Refresh the results immediately after unchecking
            this.autoSubmit()
        }
    }

    // Resets every filter on the page to its default state
    clearAllFilters(event) {
        if (event) event.preventDefault()

        // Uncheck every box linked to our search form
        const checkboxes = document.querySelectorAll('input[type="checkbox"][form="filter-form"]');
        checkboxes.forEach(cb => cb.checked = false);

        // Clear the main text search input
        const qInput = document.querySelector('input[name="q"]')
        if (qInput) qInput.value = ""

        // Refresh the results to show all communities
        this.autoSubmit()
    }
}