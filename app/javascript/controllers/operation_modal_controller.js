import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modalBody', 'dropdownBtn']

  revert() {
    
  }

  confirm({ params: { action } }) {
    setTimeout(() => {
      this.dropdownBtnTarget.disabled = true
    }, 1) 
    const confirmElement = document.createElement('div')
    confirmElement.className = 'fade show position-absolute top-0 bottom-0 start-0 end-0 bg-dark bg-opacity-50 p-3'
    confirmElement.innerHTML = `
      <div class="modal-content">
        <div class="modal-header">
          <h6 class="modal-title">Are you sure?</h6>
        </div>
        <div class="modal-body">
          This operation is irreversible.
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-action="operation-modal#${action}">Yes</button>
          <button type="button" class="btn btn-secondary" data-action="operation-modal#removeConfirm">No</button>
        </div>
      </div>
    `
    this.modalBodyTarget.appendChild(confirmElement)
    this.confirmElement = confirmElement
  }

  removeConfirm() {
    this.confirmElement.remove()
    this.dropdownBtnTarget.disabled = false
  }
}
