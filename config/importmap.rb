# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap" # @5.3.5
pin "datatables.net" # @2.2.2
pin "jquery" # @3.7.1
pin "datatables.net-bs5" # @2.2.2
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.4.1/dist/chart.js"
pin "chart.js/helpers", to: "https://ga.jspm.io/npm:chart.js@4.4.1/helpers/helpers.js"
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js"
pin "chartjs-chart-error-bars", to: "https://ga.jspm.io/npm:chartjs-chart-error-bars@4.4.3/build/index.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "mapbox-gl" # @3.11.0

# Running `bin/importmap update` will not work for popper,
# To pin the popper package manually and rename it, you can use the following commands:
#   `bin/importmap pin @popperjs/core@2.11.8/+esm --from jsdelivr`
#   `mv vendor/javascript/@popperjs--core--+esm.js vendor/javascript/@popperjs--core.js`
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "@popperjs/core/+esm", to: "@popperjs--core--+esm.js" # @2.11.8
pin "glightbox" # @3.3.1
