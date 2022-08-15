import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    document.addEventListener('turbo:before-cache', () => {
      document.querySelector('.offcanvas-backdrop.fade')?.remove()
    })
  }

  open() {
    this.menuHandler.show()
  }

  connect() {
    this.menuHandler = new bootstrap.Offcanvas(`#${this.element.id}`)
  }


  disconnect() {
    this.menuHandler.hide()
  }
}
