import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
    static targets = ["tracker"]

    connect() {
        console.log("Offcanvas Controller Connected")
    }

    toggle(event) {
        event.preventDefault()
        const panelId = event.params.id
        const targetPanel = document.getElementById(`offcanvas${panelId}`)
        if (!targetPanel) return

        if (targetPanel.classList.contains('show')) {
        return
        }

        this.closeAll()
        const instance = bootstrap.Offcanvas.getOrCreateInstance(targetPanel)
        instance.show()
        this.trackerTarget.value = panelId
    }

    close(event) {
        if (event) event.preventDefault()
        this.closeAll() 
        this.trackerTarget.value = ''
    }

    closeAll() {
        const allPanels = this.element.querySelectorAll('.offcanvas')
        allPanels.forEach(panel => {
        if (panel.classList.contains('show')) {
            const instance = bootstrap.Offcanvas.getInstance(panel)
            if (instance) {
            instance.hide()
            } else {
            panel.classList.remove('show')
            const backdrop = document.querySelector('.offcanvas-backdrop')
            if (backdrop) backdrop.remove()
            document.body.style.overflow = ''
            document.body.style.paddingRight = ''
            }
        }
        })
    }

    autoSubmit(event) {
        if (event.target.tagName === 'INPUT' || event.target.tagName === 'SELECT') {
        this.trackerTarget.form.requestSubmit()
        }
    }

    confirmClear(event) {
        if (!confirm("Are you sure you want to clear all filters?")) {
        event.preventDefault() // Stop if they click "Cancel"
        }
        // If they click "OK", the link proceeds normally (reloading the page clean)
    }

    // The function to stop the panel from opening
    stop(event) {
        event.stopPropagation();
        event.stopImmediatePropagation(); 
    }
}
