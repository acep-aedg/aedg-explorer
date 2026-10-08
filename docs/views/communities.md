# Communities Views Structure

This directory organizes the views for rendering community-related data. The structure follows a tabbed interface where each tab displays different categories of data (General, Power Generation, etc.).

## Directory Structure

- **Main Tab Views**: Located in `app/views/communities/`. Each file (e.g., `general.html.haml`, `demographics.html.haml`) corresponds to a tab on the community dashboard.
- **Section Partials**: Each tab view has a corresponding subdirectory in `app/views/communities/` containing partials for individual sections (e.g., `communities/general/_geography.html.haml`).
- **Shared Partials**: Shared components like `_map_sidebar.html.haml` are also located in `app/views/communities/` or in `app/views/shared`.
- **Layout**: The `app/views/layouts/communities.html.haml` defines the overall layout, including the navigation tabs and the `turbo_frame` where tab content is loaded.

**Example Structure:**

```sh
app/views/communities/
├── index.html.haml                # Community list/search view
├── general.html.haml              # "General" tab main view
├── demographics.html.haml         # "Demographics" tab main view
├── general/                       # Partials for the "General" tab
│   ├── _geography.html.haml
│   ├── _legislative_districts.html.haml
│   └── _transportation.html.haml
├── demographics/                  # Partials for the "Demographics" tab
│   └── ...
└── ...
```

## How Views Work

### 1. Navigation & Tabs
The tabs available for a community are defined in `app/helpers/communities_helper.rb` in the `community_navigation_tabs` method. Some tabs are conditional based on data availability (e.g., `community.power_generation?`).

### 2. Tab Rendering
When a tab is selected, it is rendered within a `turbo_frame_tag "community_tab_content"`. The layout `app/views/layouts/communities.html.haml` handles this.

### 3. Scroll Sections & Jump Links
Most tab views follow a pattern:
- They render `shared/jump_links` at the top.
- They use a `scrollspy-container` for the main content.
- Content is divided into `#anchor-name.scroll-section` divs.
- Each section usually includes a `shared/section_header` and a specific partial from the tab's subdirectory.

The jump links are defined in `app/helpers/communities/jump_link_helper.rb`.

## Adding a New Tab

1. **Routes**: Add a new member route to the `communities` resources in `config/routes.rb`.
   ```ruby
   resources :communities, only: %i[index show] do
     member do
       get :new_tab
       # ...
     end
   end
   ```
1. **Controller**: Add a new action to `CommunitiesController`.
1. **Helper**: Define the tab in `CommunitiesHelper#community_navigation_tabs`.
1. **View**: Create the main tab view in `app/views/communities/new_tab.html.haml`.
1. **Partials**: Create a directory `app/views/communities/new_tab/` for its section partials.
1. **Jump Links**: Define any jump links in `app/helpers/communities/jump_link_helper.rb`.

## Adding a New Section to an Existing Tab

1. **Partial**: Create a new partial in the tab's subdirectory (e.g., `app/views/communities/general/_new_section.html.haml`).
1. **View**: Add the section to the main tab view (e.g., `general.html.haml`) using the `scroll-section` pattern.
1. **Jump Links**: Update the jump links helper for that tab in `app/helpers/communities/jump_link_helper.rb`.
