import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['preview', 'picture', 'fileName', 'clearBtn', 'placeHolderPic', 'removeAvatarBtn']
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

  get picture() {
    return this.pictureTarget.files[0]
  }
}
