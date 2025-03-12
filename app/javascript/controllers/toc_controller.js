import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['toc'];

  connect() {
    this.generateTOC();
  }

  // This function generates a Table of Contents (TOC) based on the headings (h3 & h4) in the document. 
  generateTOC() {
    const toc = [];
    let currentH3 = null;

    document.querySelectorAll('h3, h4').forEach((heading, index) => {
      if (heading.tagName.toLowerCase() === 'h3' && heading.textContent.trim() === 'Quick Nav') {
        return;
      }
      if (!heading.id) {
        heading.id = this.generateId(heading.textContent, index);
      }

      const item = { label: heading.textContent, id: heading.id, children: [] };

      if (heading.tagName.toLowerCase() === 'h3') {
        currentH3 = item;
        toc.push(currentH3);
      } else if (heading.tagName.toLowerCase() === 'h4' && currentH3) {
        currentH3.children.push(item);
      }
    });

    this.renderTOC(toc);
  }

  generateId(text, index) {
    const baseId = text
      .toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[^\w-]/g, '')
      .substring(0, 30);

    // Ensure IDs are unique
    let uniqueId = baseId;
    let count = 1;

    while (document.getElementById(uniqueId)) {
      uniqueId = `${baseId}-${count}`;
      count++;
    }

    return uniqueId || `heading-${index}`;
  }

  renderTOC(toc) {
    this.tocTarget.innerHTML = `${toc.map(item => this.renderTOCItem(item)).join("")}`;
  }

  buildTOCHTML(toc) {
    return `<ul class="nav flex-column">${toc.map(item => this.renderTOCItem(item)).join("")}</ul>`;
  }

  renderTOCItem = (item) => {
    return `
      <div class="col-auto my-2">
        <a href="#${item.id}" class="nav-link fw-bold" data-action="click->toc#scrollTo">
          ${item.label}
        </a>
        ${
          item.children.length
            ? `<ul class="nav flex-column">${item.children.map(child => this.renderTOCSubItem(child)).join("")}</ul>`
            : ""
        }
      </div>
    `;
  };

  renderTOCSubItem = (item) => {
    return `
      <li class="nav-item">
        <a href="#${item.id}" class="nav-link" data-action="click->toc#scrollTo">${item.label}</a>
      </li>
    `;
  };

  scrollTo(event) {
    event.preventDefault();
    const target = document.querySelector(event.target.getAttribute('href'));

    if (!target) return;

    // Check if the target is inside a collapsed section
    const collapsedSection = target.closest('.collapse:not(.show)');

    if (collapsedSection) {
      // Listen for the Bootstrap collapse event to scroll AFTER it's fully expanded
      collapsedSection.addEventListener(
        'shown.bs.collapse',
        () => {
          target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        },
        { once: true } // Ensures the event only fires once
      );

      // Manually trigger the collapse to open the section
      new bootstrap.Collapse(collapsedSection, { toggle: true });
    } else {
      // If already visible, scroll immediately
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }
}
