import { Controller } from "@hotwired/stimulus"
import subscribeModal from "utils/subscribe_modal"

export default class extends Controller {
  static targets = ['confirmModal', 'iconUpdaterModal', 'iconInput', 'appendedIconInput']

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

  showIconUpdater() {
    const iconModalWrap = document.createElement('div')
    iconModalWrap.dataset.turboCache = 'false'
    iconModalWrap.innerHTML = `
      <div
        class="modal fade"
        id="updateIcon"
        tabindex="-1"
        aria-labelledby="confirmModalLabel"
        aria-hidden="true"
        data-categories-target="iconUpdaterModal"
      >
        <div class="modal-dialog modal-dialog-scrollable">
          <div class="modal-content" data-controller="operation-modal">
            <div class="modal-header">
              <h5 class="modal-title" id="confirmModalLabel">Update category icon</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" data-avatar-target="uploadArea">
              <div class="d-flex align-items-center flex-wrap" style="column-gap: 0.5rem; row-gap: 0.3rem;">
                <div class="position-relative">
                  <label for="category_icon" class="btn btn-link p-0">Upload icon locally</label>
                  <input
                    type="file"
                    id="category_icon"
                    name="category[icon]"
                    data-action="categories#uploadIconFromLocal"
                    data-categories-target="iconInput"
                    accept="image/jpeg, image/png, image/gif"
                    class="position-absolute top-0 bottom-0 end-0 start-0 opacity-0"
                  >
                </div>
                <div>|</div>
                <div>
                  <button
                    type="button"
                    class="btn btn-link p-0"
                    data-action="avatar#showUrlInput"
                    data-avatar-modal-param="true"
                  >
                    Upload from URL source
                  </button>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
          </div>
        </div>
      </div>
    `
    this.element.appendChild(iconModalWrap)

    this.iconModal = new bootstrap.Modal('#updateIcon')
    this.iconModal.show()
    
    const modalBackdrop = document.querySelector('.modal-backdrop.fade')

    this.modalResizeObserver = subscribeModal(this.element, this.iconUpdaterModalTarget, modalBackdrop)
  }

  hideIconUpdater({ detail: { removeIconInput = false } = {} } = {}) {
    removeIconInput && this.#removeAppendedIconInput()

    this.iconModal.hide()
  }

  uploadIconFromLocal() {
    this.#removeAppendedIconInput()

    const avatarController = this.application.getControllerForElementAndIdentifier(this.element, 'avatar')
    avatarController.previewTarget.src = URL.createObjectURL(this.iconInputTarget.files[0])
    this.iconInputTarget.hidden = true
    avatarController.formTarget.appendChild(this.iconInputTarget)
    avatarController.formTarget.action = avatarController.formTarget.action.split('?')[0]
    this.iconInputTarget.dataset.categoriesTarget = 'appendedIconInput'

    this.hideIconUpdater()
  }

  #removeAppendedIconInput() {
    if (this.hasAppendedIconInputTarget) {
      this.appendedIconInputTarget.remove()
    }
  }
}
