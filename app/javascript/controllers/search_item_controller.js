import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { state: Boolean }

  update(e) {
    if (this.stateValue) {
      e.currentTarget.classList.replace('on', 'off')
      this.stateValue = false
    } else {
      e.currentTarget.classList.replace('off', 'on')
      this.stateValue = true
    }

    this.dispatch('update', { detail: { state: this.stateValue } })
  }

  toggleComponent({ detail: { state }}) {
    this.element.hidden = !state
  }
}
