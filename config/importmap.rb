# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "jquery", to: "jquery.js"
pin "bootstrap", to: "bootstrap.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "slim-select" # @1.27.1
