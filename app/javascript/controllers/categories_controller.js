import { Controller } from "@hotwired/stimulus"
import subscribeModal from "utils/subscribe_modal"

export default class extends Controller {
  static targets = ['confirmModal']

  delete({ params: { id } }) {
    const confirmModalWrap = document.createElement('div')
    confirmModalWrap.dataset.turboCache = 'false'
    confirmModalWrap.innerHTML = `
      <div
        class="modal fade"
        id="confirmAction"
        tabindex="-1"
        aria-labelledby="confirmModalLabel"
        aria-hidden="true"
        data-categories-target="confirmModal"
      >
        <div class="modal-dialog modal-dialog-scrollable">
          <div class="modal-content" data-controller="operation-modal">
            <div class="modal-header">
              <h5 class="modal-title" id="confirmModalLabel">Are you sure?</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              This operation is irreversible.
            </div>
            <div class="modal-footer">
              <a
                class="btn btn-primary"
                data-turbo-method="delete"
                href="/categories/${id}"
                data-action="categories#removeResizeObserver"
              >
                Yes
              </a>
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
            </div>
          </div>
        </div>
      </div>
    `
    this.element.appendChild(confirmModalWrap)
    
    const confirmModal = new bootstrap.Modal('#confirmAction')
    confirmModal.show()
    const modalBackdrop = document.querySelector('.modal-backdrop.fade')

    this.modalResizeObserver = subscribeModal(this.element, this.confirmModalTarget, modalBackdrop)
  }

  removeResizeObserver() {
    this.modalResizeObserver.unobserve(this.element)
  }
}
