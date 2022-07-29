import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { minwidth: Number }
  static targets = ['element']
  static classes = ['triggered']

  #compareParentChildWidths = () => {
    const getParentWidth = (elt) => {
      const clientWidth = elt.clientWidth
      const paddLeft = window.getComputedStyle(this.element).paddingLeft.replace('px', '')
      const paddRight = window.getComputedStyle(this.element).paddingRight.replace('px', '')
      return clientWidth - paddLeft - paddRight
    }
    const parentWidth = getParentWidth(this.element)
    const childWidth = this.elementTarget.offsetWidth
    if (parentWidth === childWidth) {
      this.elementTarget.classList.add(this.triggeredClass)
    } else {
      this.elementTarget.classList.remove(this.triggeredClass)
    }
  }

  #resizeObserver = new ResizeObserver(() => {
    this.#compareParentChildWidths()
  })

  #addObserver = (e) => {
    if (e.matches) {
      this.#resizeObserver.observe(this.elementTarget)
    } else {
      this.#resizeObserver.unobserve(this.elementTarget)
      this.elementTarget.classList.remove(this.triggeredClass)
    }
  }

  #mediaQuery = this.hasMinwidthValue && window.matchMedia(`(min-width: ${this.minwidthValue}px)`)

  connect() {
    if (this.#mediaQuery) {
      this.#mediaQuery.addEventListener('change', this.#addObserver)
      if (this.#mediaQuery.matches) {
        this.#addObserver(this.#mediaQuery)
      }
    } else {
      this.#resizeObserver.observe(this.elementTarget)
    }
  }

  disconnect() {
    this.#mediaQuery && this.#mediaQuery.removeEventListener('change', this.#addObserver)
    this.#resizeObserver.disconnect()
  }
}
