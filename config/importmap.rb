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
