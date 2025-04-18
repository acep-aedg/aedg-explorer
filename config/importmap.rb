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
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.8/dist/chart.umd.js"
pin "@kurkle/color", to: "https://cdn.jsdelivr.net/npm/@kurkle/color@0.3.4/dist/color.esm.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "mapbox-gl" # @3.11.0
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "@popperjs/core/+esm", to: "@popperjs--core--+esm.js" # @2.11.8
