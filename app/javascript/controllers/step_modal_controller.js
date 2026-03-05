// step_modal_controller.js
// Manages the multi-step Add Milestone modal.
import { Controller } from "@hotwired/stimulus"

const INTENSITY_LABELS = {
  1: "Very gentle", 2: "Gentle", 3: "Gentle",
  4: "Moderate",    5: "Moderate", 6: "Moderate",
  7: "Strong",      8: "Strong",
  9: "Intense",     10: "Very intense",
}

const STEP_HEADINGS = {
  1: "Choose a type",
  2: "Add details",
  3: "Perspectives",
}

export default class extends Controller {
  static targets = [
    "step", "dot", "heading",
    "titleInput", "intensitySlider", "intensityLabel",
    "repairSection", "panel", "form",
  ]

  connect() {
    this.currentStep  = 1
    this.selectedType = null
    this.totalSteps   = 3
    this.renderStep()
  }

  // ── Navigation ───────────────────────────────────────────

  nextStep() {
    if (!this.validateCurrentStep()) return
    if (this.currentStep < this.totalSteps) {
      this.currentStep++
      this.renderStep()
    }
  }

  prevStep() {
    if (this.currentStep > 1) {
      this.currentStep--
      this.renderStep()
    }
  }

  // ── Type selection ────────────────────────────────────────

  selectType({ params: { type } }) {
    this.selectedType = type
    // Show/hide repair section on step 3 depending on type
    if (this.hasRepairSectionTarget) {
      if (type === "conflict") {
        this.repairSectionTarget.classList.remove("hidden")
      } else {
        this.repairSectionTarget.classList.add("hidden")
      }
    }
  }

  // ── Intensity slider ──────────────────────────────────────

  updateIntensity() {
    const value = parseInt(this.intensitySliderTarget.value, 10)
    this.intensityLabelTarget.textContent = INTENSITY_LABELS[value] || "Moderate"
  }

  // ── Backdrop close ────────────────────────────────────────

  closeOnBackdrop(event) {
    if (event.target === this.element) {
      window.history.back()
    }
  }

  // ── Rendering ─────────────────────────────────────────────

  renderStep() {
    // Show/hide step panels
    this.stepTargets.forEach(step => {
      const stepNum = parseInt(step.dataset.step, 10)
      if (stepNum === this.currentStep) {
        step.classList.remove("hidden")
      } else {
        step.classList.add("hidden")
      }
    })

    // Update dots
    this.dotTargets.forEach(dot => {
      const dotStep = parseInt(dot.dataset.step, 10)
      dot.classList.remove("active", "done")
      if (dotStep === this.currentStep) {
        dot.classList.add("active")
      } else if (dotStep < this.currentStep) {
        dot.classList.add("done")
      }
    })

    // Update heading
    if (this.hasHeadingTarget) {
      this.headingTarget.textContent = STEP_HEADINGS[this.currentStep] || ""
    }

    // Focus title on step 2
    if (this.currentStep === 2 && this.hasTitleInputTarget) {
      setTimeout(() => this.titleInputTarget.focus(), 100)
    }
  }

  // ── Validation ────────────────────────────────────────────

  validateCurrentStep() {
    if (this.currentStep === 1) {
      const checked = this.element.querySelector('input[name="milestone[milestone_type]"]:checked')
      if (!checked) {
        this.shakeStep()
        return false
      }
      this.selectedType = checked.value
    }
    if (this.currentStep === 2) {
      const title = this.hasTitleInputTarget ? this.titleInputTarget.value.trim() : ""
      if (!title) {
        this.titleInputTarget.focus()
        this.titleInputTarget.classList.add("ring-2", "ring-rose-300")
        setTimeout(() => this.titleInputTarget.classList.remove("ring-2", "ring-rose-300"), 2000)
        return false
      }
    }
    return true
  }

  shakeStep() {
    const panel = this.hasPanelTarget ? this.panelTarget : this.element
    panel.classList.add("translate-x-1")
    setTimeout(() => panel.classList.remove("translate-x-1"), 80)
    setTimeout(() => panel.classList.add("-translate-x-1"), 80)
    setTimeout(() => panel.classList.remove("-translate-x-1"), 160)
  }
}
