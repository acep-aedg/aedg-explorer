import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tracker"]

    connect() {
        this.externalClickListener = this.closeOnOutsideClick.bind(this)
        window.addEventListener("click", this.externalClickListener)
    }

    disconnect() {
        window.removeEventListener("click", this.externalClickListener)
    }

    toggle(event) {
        event.preventDefault()
        event.stopPropagation()

        const panelId = event.params.id
        const targetPanel = document.getElementById(panelId)
        if (!targetPanel) return

        if (targetPanel.classList.contains('panel-visible')) {
            this.close()
        } else {
            this.closeAll() // Close others
            targetPanel.classList.add('panel-visible')
            if (this.hasTrackerTarget) this.trackerTarget.value = panelId
        }
    }

    close() {
        this.closeAll()
        if (this.hasTrackerTarget) this.trackerTarget.value = ""

        // Refresh results when we close the panel
        this.autoSubmit({ target: { tagName: 'INPUT' } })
    }

    closeAll() {
        // Only removes our custom visibility class
        this.element.querySelectorAll('.panel-visible').forEach(panel => {
            panel.classList.remove('panel-visible')
        })
    }

    closeOnOutsideClick(event) {
        const openPanel = this.element.querySelector('.panel-visible')
        if (!openPanel) return

        const isInside = openPanel.contains(event.target)
        const isNav = event.target.closest('[data-action*="search-panels#toggle"]')

        // IMPORTANT: If they click INSIDE (the filters), do nothing!
        if (isInside || isNav) return

        this.close()
    }

    uncheckSpecific(event) {
        // This 'id' matches the 'search_panels_id_param' from the HAML
        const checkboxId = event.params.id;

        console.log("Looking for checkbox with ID:", checkboxId);

        const checkbox = document.getElementById(checkboxId);
        if (checkbox) {
            checkbox.checked = false;
            console.log("Checkbox found and unchecked!");
        } else {
            console.error("Could not find checkbox. Check if the ID in HAML matches the ID in the panel.");
        }

    }

    clearAllFilters(event) {
        if (event) event.preventDefault();

        const form = document.getElementById('filter-form');
        if (!form) return;

        // Uncheck every checkbox associated with the filter form
        const checkboxes = document.querySelectorAll('input[type="checkbox"][form="filter-form"]');
        checkboxes.forEach(cb => cb.checked = false);

        // Clear the search input and the hidden expanded tracker
        const searchInput = document.querySelector('input[name="q"][form="filter-form"]');
        if (searchInput) searchInput.value = "";

        if (this.hasTrackerTarget) {
            this.trackerTarget.value = "";
        }

        // Close the panels visually
        this.closeAll();

        // Submit the cleared form to the server
        form.requestSubmit();
    }

    autoSubmit(event) {
        // Only respond to input/select changes
        if (event.target && !['INPUT', 'SELECT'].includes(event.target.tagName)) return

        clearTimeout(this.submitTimeout)

        this.submitTimeout = setTimeout(() => {
            const form = document.getElementById('filter-form')
            if (!form) return

            if (this.hasTrackerTarget) {
                const openPanel = this.element.querySelector('.panel-visible')
                this.trackerTarget.value = openPanel ? openPanel.id : ""
            }

            // Trigger Turbo's native form submission
            // requestSubmit() ensures that Turbo's data-attributes are respected
            form.requestSubmit()
        }, 400)
    }
}