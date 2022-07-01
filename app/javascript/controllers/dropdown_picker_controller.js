import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['categoriesInput', 'dropdownList', 'dropdown']

  pick({ params: { id }, currentTarget }) {
    this.dispatch('select', { detail: id })
    currentTarget.parentElement.hidden = true
    this.dispatch('updated')
    const categories = this.categoriesInputTarget.value
    this.categoriesInputTarget.value = categories ? JSON.stringify([...JSON.parse(categories), id]) : JSON.stringify([id])
  }

  unselect({ detail: id }) {
    [...this.dropdownListTarget.children].find((element) => element.dataset.id === id.toString()).hidden = false
    this.dispatch('updated')
    const categories = JSON.parse(this.categoriesInputTarget.value).filter((v) => v !== id)
    this.categoriesInputTarget.value = categories.length ? JSON.stringify(categories) : ''
  }

  updateDropdownList() {
    this.dropdownTarget.hidden = [...this.dropdownListTarget.children].every((element) => element.hidden)
  }
}
