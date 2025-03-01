# Communities Views Structure

This directory organizes the views for rendering community-related data. The `sections/` directory contains partials that are used to render collapsible sections from the `show` view.

## Naming & Directory Structure
- The `sections/` directory contains partials for collapsible sections.
- Each `.html.haml` file in `sections/` corresponds to a section on the community page.
- Each section has its own subdirectory containing related partials.
- These sections are rendered in **the order defined in `show.html.haml`**.

**Example Structure**
```sh
views/communities/
├── _community.json.jbuilder       # JSON representation of community data
├── _dropdown.html.haml            # Dropdown partial
├── index.html.haml                # Index view
├── index.json.jbuilder            
├── show.html.haml                 # Show view (defines order and renders section)
├── show.json.jbuilder             
└── sections/                      # Contains collapsible sections & related partials
    ├── _background.html.haml       # Background section
    ├── _electricity.html.haml      # Electricity section
    ├── background/                 # Partials for "Background"
    │   ├── _election_districts.html.haml
    │   ├── _geography.html.haml
    │   ├── _population_employment.html.haml
    │   └── _transportation.html.haml
    ├── electricity/                # Partials for "Electricity"
    │   ├── _fuel.html.haml
    │   ├── _production.html.haml
    │   ├── _rates.html.haml
    │   ├── _sales_revenue_customers.html.haml
    │   └── _utility.html.haml
```
### Rendering Behavior
- Each section in `sections/` is included in `show.html.haml`, defining the display order.
- Sections are collapsible to keep the UI clean and structured.
- Partials within each section’s subdirectory are used for rendering subsections.

### Adding a New Section
1. Create a new partial in `sections/` (e.g., `_new_section.html.haml`).
1. If subsections are neeeded for the section, create a **corresponding** subdirectory (`sections/new_section/`).
   -  Add related partials inside the new section directory.
1. Update `show.html.haml` to include the new section in the correct order.