import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: Number }

  select({ detail: id }) {
    if (this.idValue === id) {
      this.element.hidden = false
    }
  }

  remove() {
    this.element.hidden = true
    this.dispatch('unselect', { detail: this.idValue })
  }
}
