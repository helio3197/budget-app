import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'preview',
    'picture',
    'fileName',
    'clearBtn',
    'placeHolderPic',
    'removeAvatarBtn',
    'uploadArea',
    'imgUrl',
  ]
  static values = { placeholderPic: String }

  connect() {
    this.defaultAvatar = this.previewTarget.src
  }

  update() {
    if (this.picture) {
      this.previewTarget.src = URL.createObjectURL(this.picture)
      this.fileNameTarget.textContent = this.picture.name
      this.clearBtnTarget.className = ''
      if (this.avatarRemoved) {
        document.getElementById('remove_avatar').remove()
      }
      if (this.hasRemoveAvatarBtnTarget) {
        this.removeAvatarBtnTarget.className = 'd-none'
      }
    } else {
      this.previewTarget.src = this.defaultAvatar
      this.fileNameTarget.textContent = 'No file chosen...'
      this.clearBtnTarget.className = 'd-none'
      if (this.hasRemoveAvatarBtnTarget) {
        this.removeAvatarBtnTarget.className = 'remove-avatar btn-to-link'
      }
      this.avatarRemoved = false
      if (this.avatarRemoved && this.previewTarget.src === this.placeholderPicValue) {
        this.removeAvatar()
      }
    }
  }

  destroy() {
    this.pictureTarget.value = ''
    this.update()
  }

  removeAvatar() {
    this.previewTarget.src = this.placeholderPicValue
    this.removeAvatarBtnTarget.className = 'd-none'
    const removeAvatarInput = document.createElement('input')
    removeAvatarInput.type = 'hidden'
    removeAvatarInput.name = 'user[remove_avatar]'
    removeAvatarInput.value = 'true'
    removeAvatarInput.id = 'remove_avatar'
    document.getElementById('edit_user').appendChild(removeAvatarInput)
    this.avatarRemoved = true
  }

  showUrlInput() {
    this.originalUploadArea = this.uploadAreaTarget.cloneNode(true)
    this.uploadAreaTarget.innerHTML = `
      <div class="input-group has-validation">
        <input
          type="text"
          class="form-control"
          placeholder="Image source URL"
          style="min-width: 100px"
          data-avatar-target="imgUrl"
        >
        <button class="btn btn-outline-primary" type="button" data-action="avatar#processImgUrl">
          <span class="d-none d-sm-inline">Ok</span>
          <i class="fa-solid fa-check"></i>
        </button>
        <button class="btn btn-outline-secondary" type="button" data-action="avatar#hideUrlInput">
          <span class="d-none d-sm-inline">Cancel</span>
          <i class="fa-solid fa-xmark"></i>
        </button>
        <div class="invalid-feedback">
          URL invalid.
        </div>
      </div>
    `
  }

  hideUrlInput() {
    this.uploadAreaTarget.replaceWith(this.originalUploadArea)
  }

  processImgUrl() {
    if (!/^https?:\/\/(?:[\w-]+\.)?[\w-]+\.\w{2,3}(?:\/.+)$/.test(this.imgUrlTarget.value)) {
      this.imgUrlTarget.classList.add('is-invalid')
      return
    }

    this.previewTarget.src = `/get-image?img=${this.imgUrlTarget.value}`
    this.formElement = this.imgUrlTarget.form
    this.formElement.action += `?img=${this.imgUrlTarget.value}`
    this.uploadAreaTarget.innerHTML = `
      <div class="file-selection">
        <small class="fs-6">${this.imgUrlTarget.value}</small>
        <button type="button" data-action="avatar#removeUrlImg">
          <i class="fa-solid fa-xmark"></i>
        </button>
      </div>
    `
    return
  }

  removeUrlImg() {
    this.formElement.action = this.formElement.action.split('?')[0]
    this.hideUrlInput()
    this.previewTarget.src = this.placeholderPicValue
  }

  get picture() {
    return this.pictureTarget.files[0]
  }
}
