class ReflectionsController < ApplicationController
  before_action :require_relationship

  def index
    @reflections = @relationship.reflections.recent
    @reflection  = @relationship.reflections.new
    @prompts     = Reflection::PROMPTS
  end

  def create
    @reflection = @relationship.reflections.new(reflection_params)
    if @reflection.save
      respond_to do |format|
        format.html  { redirect_to relationship_reflections_path(@relationship), notice: "Your reflection is saved." }
        format.turbo_stream
        format.json  { render json: { id: @reflection.id, saved: true } }
      end
    else
      respond_to do |format|
        format.html  { render :index, status: :unprocessable_entity }
        format.json  { render json: { saved: false }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @reflection = @relationship.reflections.find(params[:id])
    @reflection.update(reflection_params)
    respond_to do |format|
      format.json { render json: { saved: true } }
    end
  end

  def destroy
    @relationship.reflections.find(params[:id]).destroy
    redirect_to relationship_reflections_path(@relationship)
  end

  private

  def reflection_params
    params.require(:reflection).permit(:content, :prompt_type, :private_note)
  end
end
