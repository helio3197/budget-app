import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { modalId: String }

  

  show(e) {
    const modalFrame = document.getElementById('operation-modal')
    const showModal = () => {
      const modal = new bootstrap.Modal(`#${this.modalIdValue}`)
      const modalParent = document.getElementById('modal-parent')
      const scrollPos = modalParent.scrollTop
      const modalElement = document.getElementById(this.modalIdValue)
      modal.show()
      modalElement.addEventListener('hide.bs.modal', () => {
        modalParent.style = null
      })
      modalParent.style.setProperty('overflow', 'hidden', 'important')
      const modalBackdrop = document.querySelector('.modal-backdrop.fade')
      document.getElementById('modal-backdrop').replaceWith(modalBackdrop)
      modalBackdrop.style.top = `${scrollPos}px`
      modalElement.style.top = `${scrollPos}px`
      modalFrame.removeEventListener('turbo:frame-load', showModal)
    }
    modalFrame.addEventListener('turbo:frame-load', showModal)
  }
}
