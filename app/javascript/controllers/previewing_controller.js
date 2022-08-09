import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['loading']

  connect() {
    if (document.documentElement.hasAttribute('data-turbo-preview')) {
      this.loadingTarget.classList.remove('d-none')
    }
  }
}
