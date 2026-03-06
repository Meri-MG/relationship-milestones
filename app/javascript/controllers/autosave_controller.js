// autosave_controller.js
// Debounced autosave for reflection text areas.
// Saves to server after 1.2 s of inactivity.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "status"]
  static values  = {
    url:            String,
    reflectionId:   { type: Number, default: 0 },
    debounceMs:     { type: Number, default: 1200 },
  }

  connect() {
    this._timer  = null
    this._saved  = false
  }

  disconnect() {
    clearTimeout(this._timer)
  }

  scheduleSave() {
    clearTimeout(this._timer)
    this.setStatus("…")
    this._timer = setTimeout(() => this.save(), this.debounceMsValue)
  }

  async save() {
    const content = this.fieldTarget.value.trim()
    if (!content) return

    const promptType = this.element.querySelector('[name="reflection[prompt_type]"]')?.value

    const body = new FormData()
    body.append("reflection[content]",     content)
    body.append("reflection[prompt_type]", promptType || "open")

    const headers = {
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      "Accept":       "application/json",
    }

    try {
      let response
      if (this.reflectionIdValue > 0) {
        response = await fetch(`${this.urlValue}/${this.reflectionIdValue}`, {
          method: "PATCH", headers, body,
        })
      } else {
        response = await fetch(this.urlValue, {
          method: "POST", headers, body,
        })
        if (response.ok) {
          const data = await response.json()
          if (data.id) this.reflectionIdValue = data.id
        }
      }

      if (response.ok) {
        this.setStatus("Saved")
        setTimeout(() => this.setStatus(""), 3000)
      } else {
        this.setStatus("Not saved")
      }
    } catch {
      this.setStatus("No connection")
    }
  }

  setStatus(msg) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = msg
    }
  }
}
