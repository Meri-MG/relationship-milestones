// modal_controller.js
// Simple show/hide for confirmation modals (end chapter, new chapter).
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { target: String }

  open() {
    const modal = document.getElementById(this.targetValue)
    if (modal) {
      modal.classList.remove("hidden")
      document.body.style.overflow = "hidden"
    }
  }

  close() {
    this.element.classList.add("hidden")
    document.body.style.overflow = ""
  }

  // Close on backdrop click
  backdropClick(event) {
    if (event.target === this.element) {
      this.close()
    }
  }
}
