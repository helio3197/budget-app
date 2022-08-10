import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    name: String,
    paths: Array,
  }

  initialize() {
    this.originalChild = this.element.firstElementChild
  }

  connect() {
    const currentPath = window.location.pathname.match(/^\/$|(?:.+[^\/])/)[0]
    if (this.pathsValue.some((path) => {
      if (path === '/') return path === currentPath

      return currentPath.includes(path)
    })) {
      this.element.innerHTML = `
        <p class="${this.originalChild.className} text-primary bg-light">${this.nameValue}</p>
      `
    } else if (this.element.firstElementChild.tagName !== 'A') {
      this.element.firstElementChild.replaceWith(this.originalChild)
    }
  }
}
