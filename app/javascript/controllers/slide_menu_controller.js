import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.menuHandler = new bootstrap.Offcanvas(`#${this.element.id}`)
  }

  connect() {
    const fixFade = document.querySelector('.offcanvas-backdrop.fade')
    fixFade && fixFade.remove()
  }

  disconnect() {
    this.menuHandler.hide()
  }
}
