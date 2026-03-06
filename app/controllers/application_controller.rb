class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_current_relationship

  private

  def set_current_relationship
    @relationship = if params[:relationship_id].present?
      Relationship.find(params[:relationship_id])
    elsif session[:relationship_id].present?
      Relationship.find_by(id: session[:relationship_id])
    end
  rescue ActiveRecord::RecordNotFound
    session.delete(:relationship_id)
    nil
  end

  def require_relationship
    redirect_to root_path, alert: "No active chapter found." unless @relationship
  end
end
