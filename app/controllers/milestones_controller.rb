class MilestonesController < ApplicationController
  before_action :require_relationship
  before_action :set_milestone, only: [:show, :edit, :update, :destroy]

  def new
    @milestone = @relationship.milestones.new(occurred_on: Date.today)
    @step      = (params[:step] || 1).to_i
  end

  def create
    @milestone = @relationship.milestones.new(milestone_params)
    if @milestone.save
      respond_to do |format|
        format.html { redirect_to @relationship, notice: "A moment has been recorded." }
        format.turbo_stream
      end
    else
      @step = 2
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    @step = 2
  end

  def update
    if @milestone.update(milestone_params)
      redirect_to @relationship, notice: "The milestone has been updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @milestone.destroy
    redirect_to @relationship, notice: "The milestone has been removed."
  end

  private

  def set_milestone
    @milestone = @relationship.milestones.find(params[:id])
  end

  def milestone_params
    params.require(:milestone).permit(
      :title, :occurred_on, :milestone_type,
      :description, :my_perspective, :partner_perspective,
      :repair_notes, :emotional_intensity, :photo,
      emotional_tags: []
    )
  end
end
