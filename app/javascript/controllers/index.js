// controllers/index.js — auto-loads all Stimulus controllers
import { application } from "controllers/application"

import MilestoneCardController from "controllers/milestone_card_controller"
application.register("milestone-card", MilestoneCardController)

import StepModalController from "controllers/step_modal_controller"
application.register("step-modal", StepModalController)

import AutosaveController from "controllers/autosave_controller"
application.register("autosave", AutosaveController)

import ReflectionPromptController from "controllers/reflection_prompt_controller"
application.register("reflection-prompt", ReflectionPromptController)

import ModalController from "controllers/modal_controller"
application.register("modal", ModalController)
