// milestone_card_controller.js
// Toggles the expanded/collapsed state of a timeline milestone card.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["collapsed", "expanded", "chevron"]

  toggle() {
    const isExpanded = !this.expandedTarget.classList.contains("hidden")

    if (isExpanded) {
      this.collapse()
    } else {
      this.expand()
    }
  }

  expand() {
    this.expandedTarget.classList.remove("hidden")
    this.chevronTarget.style.transform = "rotate(180deg)"
    this.element.classList.add("shadow-card-md")
  }

  collapse() {
    this.expandedTarget.classList.add("hidden")
    this.chevronTarget.style.transform = "rotate(0deg)"
    this.element.classList.remove("shadow-card-md")
  }
}
