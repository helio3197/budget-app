import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['categoriesInput', 'dropdownList', 'dropdown']

  pick({ params: { id }, currentTarget }) {
    this.dispatch('select', { detail: id })
    currentTarget.parentElement.hidden = true
    this.dispatch('updated')
  }

  unselect({ detail: id }) {
    [...this.dropdownListTarget.children].find((element) => element.dataset.id === id.toString()).hidden = false
    this.dispatch('updated')
  }

  updateDropdownList() {
    this.dropdownTarget.hidden = [...this.dropdownListTarget.children].every((element) => element.hidden)
  }
}
