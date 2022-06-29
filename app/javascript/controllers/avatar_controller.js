import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['preview', 'picture', 'fileName', 'clearBtn']

  connect() {
    this.defaultAvatar = this.previewTarget.src
  }

  update() {
    if (this.picture) {
      this.previewTarget.src = URL.createObjectURL(this.picture)
      this.fileNameTarget.textContent = this.picture.name
      this.clearBtnTarget.className = ''
    } else {
      this.previewTarget.src = this.defaultAvatar
      this.fileNameTarget.textContent = 'No file chosen...'
      this.clearBtnTarget.className = 'd-none'
    }
  }

  destroy() {
    this.pictureTarget.value = ''
    this.update()
  }

  get picture() {
    return this.pictureTarget.files[0]
  }
}
