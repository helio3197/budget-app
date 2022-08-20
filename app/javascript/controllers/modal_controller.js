import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { modalId: String }

  show() {
    const modalFrame = document.getElementById('operation-modal')
    const showModal = () => {
      const modal = new bootstrap.Modal(`#${this.modalIdValue}`)
      const modalParent = document.getElementById('modal-parent')
      modal.show()
      const modalElement = document.getElementById(this.modalIdValue)
      const modalBackdrop = document.querySelector('.modal-backdrop.fade')
      modalBackdrop.dataset.turboCache = 'false'

      const resizeObserver = new ResizeObserver(() => {
        modalBackdrop.style.top = `${modalParent.offsetTop}px`
        modalBackdrop.style.left = `${modalParent.offsetLeft}px`
        modalElement.style.top = `${modalParent.offsetTop}px`
        modalElement.style.left = `${modalParent.offsetLeft}px`
        modalElement.style.width = `${modalParent.offsetWidth}px`
        modalElement.firstElementChild.style.height = `calc(${modalParent.offsetHeight}px - var(--bs-modal-margin) * 2)`
      })
      resizeObserver.observe(modalParent)
      modalElement.addEventListener('hide.bs.modal', () => {
        resizeObserver.unobserve(modalParent)
      })
      modalFrame.removeEventListener('turbo:frame-load', showModal)
    }
    modalFrame.addEventListener('turbo:frame-load', showModal)
  }
}
