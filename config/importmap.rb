# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: 'bootstrap.min.js' # @5.3.0
pin "datatables.net" # @2.2.2
pin "jquery" # @3.7.1
pin "datatables.net-bs5" # @2.2.2
pin "@popperjs/core", to: "popper-lib.js" # @2.11.8
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.8/dist/chart.umd.js"
pin "@kurkle/color", to: "https://cdn.jsdelivr.net/npm/@kurkle/color@0.3.4/dist/color.esm.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "mapbox-gl" # @3.10.0
