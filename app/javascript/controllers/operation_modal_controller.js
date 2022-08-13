import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modalBody', 'dropdownBtn']

  revert({ params: { id, categoryId } }) {
    const form = document.createElement('form')
    form.hidden = true
    form.method = 'post'
    form.action = `/operations/${id}`
    form.dataset.turboFrame = '_top'
    const inputMethod = document.createElement('input')
    inputMethod.name = '_method'
    inputMethod.value = 'patch'
    const inputCSRF = document.createElement('input')
    inputCSRF.name = document.querySelector('[name="csrf-param"]').content
    inputCSRF.value = document.querySelector('[name="csrf-token"]').content
    const inputReverted = document.createElement('input')
    inputReverted.name = 'operation[reverted]'
    inputReverted.value = 'true'
    const inputCategoryId = document.createElement('input')
    inputCategoryId.name = 'operation[category_id]'
    inputCategoryId.value = categoryId
    form.appendChild(inputReverted)
    form.appendChild(inputMethod)
    form.appendChild(inputCSRF)
    form.appendChild(inputCategoryId)
    this.modalBodyTarget.appendChild(form)
    form.requestSubmit()
  }

  confirm({ params: { action, actionParams } }) {
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
          <button
            type="button"
            class="btn btn-primary"
            data-action="operation-modal#${action}"
            ${Object.entries(actionParams).map((e) => (`data-operation-modal-${e[0]}-param="${e[1]}"`)).join(' ')}
          >
            Yes
          </button>
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
