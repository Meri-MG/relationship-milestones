class RelationshipsController < ApplicationController
  def new
    @relationship = Relationship.new
  end

  def create
    @relationship = Relationship.new(relationship_params)
    if @relationship.save
      session[:relationship_id] = @relationship.id
      redirect_to @relationship, notice: "Your chapter has begun."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @relationship = Relationship.find(params[:id])
    session[:relationship_id] = @relationship.id

    @filter       = params[:filter]
    @milestones   = filtered_milestones
    @chapters     = chapter_chain
  end

  def end_chapter
    @relationship.end_chapter!
    redirect_to @relationship, notice: "This chapter has come to an end."
  end

  def new_chapter
    child = @relationship.new_chapter!(title: @relationship.title)
    session[:relationship_id] = child.id
    redirect_to child, notice: "A new beginning."
  end

  private

  def relationship_params
    params.require(:relationship).permit(:title, :mode, :began_on, :description)
  end

  def filtered_milestones
    scope = @relationship.milestones
    scope = scope.by_type(@filter) if @filter.present?
    scope.order(occurred_on: :asc)
  end

  def chapter_chain
    chain = [ @relationship ]
    current = @relationship
    while current.parent_chapter
      current = current.parent_chapter
      chain.unshift(current)
    end
    chain
  end
end
