import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['preview', 'picture']

  connect() {
    this.defaultAvatar = this.previewTarget.src
  }

  update() {
    if (this.picture)
      this.previewTarget.src = URL.createObjectURL(this.picture)
    else
      this.previewTarget.src = this.defaultAvatar
  }

  get picture() {
    return this.pictureTarget.files[0]
  }
}
