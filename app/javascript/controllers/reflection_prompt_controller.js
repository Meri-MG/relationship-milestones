// reflection_prompt_controller.js
// Expands/collapses inline reflection editors under each prompt card.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "editor", "form"]

  activate({ params: { key } }) {
    // Collapse all
    this.editorTargets.forEach(ed => ed.classList.add("hidden"))
    this.cardTargets.forEach(card => card.classList.remove("ring-1", "ring-sage-200"))

    // Expand the targeted one
    const editor = this.editorTargets.find(ed => ed.dataset.key === key)
    const card   = this.cardTargets.find(c  => c.dataset.key   === key)

    if (editor) {
      editor.classList.remove("hidden")
      const textarea = editor.querySelector("textarea")
      if (textarea) {
        setTimeout(() => {
          textarea.focus()
          // Place cursor at end
          const len = textarea.value.length
          textarea.setSelectionRange(len, len)
        }, 50)
      }
    }
    if (card) {
      card.classList.add("ring-1", "ring-sage-200")
    }
  }

  collapse({ params: { key } }) {
    const editor = this.editorTargets.find(ed => ed.dataset.key === key)
    const card   = this.cardTargets.find(c  => c.dataset.key   === key)
    if (editor) editor.classList.add("hidden")
    if (card)   card.classList.remove("ring-1", "ring-sage-200")
  }
}
