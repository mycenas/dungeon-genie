# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "three", to: "https://ga.jspm.io/npm:three@0.155.0/build/three.module.js"
pin "three/examples/jsm/loaders/GLTFLoader.js", to: "https://ga.jspm.io/npm:three@0.155.0/examples/jsm/loaders/GLTFLoader.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
