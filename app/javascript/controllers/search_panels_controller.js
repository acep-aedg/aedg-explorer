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
        const form = document.getElementById('filter-form');
        const checkbox = event.currentTarget;
        const name = checkbox.name; // e.g., "grid_ids[]"
        const value = checkbox.value;

        // Sync the checkbox state to the Hidden Form
        if (checkbox.checked) {
            // Add hidden input if it doesn't exist
            if (!form.querySelector(`input[name="${name}"][value="${value}"]`)) {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = name;
                input.value = value;
                form.appendChild(input);
            }
        } else {
            // Remove hidden input if unchecked
            const existing = form.querySelector(`input[name="${name}"][value="${value}"]`);
            if (existing) existing.remove();
        }

        // Sync Pagination/Alpha from URL
        const urlParams = new URLSearchParams(window.location.search);
        document.querySelectorAll('[id^="hidden_alpha_"], [id^="hidden_page_"]').forEach(el => {
            if (urlParams.has(el.name)) el.value = urlParams.get(el.name);
        });

        // Reset main results page
        const mainPage = form.querySelector('input[name="page"]');
        if (mainPage) mainPage.value = "";

        form.requestSubmit();
    }

    // Add this to your search-panels controller
    autoSubmitSearch(event) {
        // Clear the old timer
        clearTimeout(this.searchTimeout)

        this.searchTimeout = setTimeout(() => {
            const queryValue = event.target.value;
            const brainForm = document.getElementById('filter-form');
            const resultsFrame = document.getElementById('results_frame');

            if (!brainForm) {
                console.error("The 'filter-form' (Brain) was not found in the DOM.");
                return;
            }

            //  Sync the search value into the Brain Form's hidden 'q' field
            const hiddenQ = brainForm.querySelector('input[name="q"]');
            if (hiddenQ) {
                hiddenQ.value = queryValue;
            }

            // Reset the main results page to 1
            const mainPage = brainForm.querySelector('input[name="page"]');
            if (mainPage) mainPage.value = "";

            // Visual feedback
            if (resultsFrame) resultsFrame.style.opacity = '0.5';
            brainForm.requestSubmit();

        }, 600);
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

    clearAllFilters(event) {
        event.preventDefault();

        // Dim the results for feedback
        const resultsFrame = document.getElementById('results_frame');
        if (resultsFrame) resultsFrame.style.opacity = '0.5';

        // This bypasses the form entirely and just resets the browser state
        Turbo.visit("/search/advanced", { action: "advance" });
    }

    uncheckSpecific(event) {
        // We don't preventDefault here because we want the link_to URL to load,
        // but we use this to keep our hidden form in sync immediately.
        const { id } = event.currentTarget.dataset;
        const checkbox = document.getElementById(id);

        if (checkbox) {
            checkbox.checked = false;
            // If you want it to submit immediately upon clicking the 'X' on a badge:
            // document.getElementById('filter-form').requestSubmit();
        }
    }


    setAlpha(event) {
        const letter = event.params.letter;
        const prefix = event.params.prefix;
        const form = document.getElementById('filter-form');

        // Update the Alphabet filter
        const alphaInput = form.querySelector(`#hidden_alpha_${prefix}`);
        if (alphaInput) alphaInput.value = letter;

        // Reset the Facet's Page to 1
        const pageInput = form.querySelector(`#hidden_page_${prefix}`);
        if (pageInput) pageInput.value = "";

        // Reset the Main results page
        const mainPage = form.querySelector('input[name="page"]');
        if (mainPage) mainPage.value = "";

        form.requestSubmit();
    }
}