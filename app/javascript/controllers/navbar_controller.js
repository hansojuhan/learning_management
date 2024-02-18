import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  toggle() {
    const element = document.getElementById("mobile-links")
    const barsElement = document.getElementById("bars")
    const closeElement = document.getElementById("close")

    element.classList.toggle("hidden")
    barsElement.classList.toggle("hidden")
    closeElement.classList.toggle("hidden")
  }
}
