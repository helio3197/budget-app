import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  openMenu() {
    this.dispatch('openmenu')
  }
}
