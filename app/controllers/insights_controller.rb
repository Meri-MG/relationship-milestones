class InsightsController < ApplicationController
  before_action :require_relationship

  def show
    milestones = @relationship.milestones.unscope(:order)

    @total_milestones   = milestones.count
    @by_type            = milestones.group(:milestone_type).count
    @monthly_activity   = milestones
                            .group_by { |m| m.occurred_on.beginning_of_month }
                            .transform_values(&:count)
                            .sort.to_h
    @avg_intensity      = milestones.average(:emotional_intensity)&.round(1)
    @conflict_count     = milestones.by_type("conflict").count
    @growth_count       = milestones.by_type("growth").count
    @repair_notes_count = milestones.by_type("conflict").where.not(repair_notes: [nil, ""]).count
    @repair_rate        = @conflict_count.zero? ? 0 :
                          ((@repair_notes_count.to_f / @conflict_count) * 100).round

    @chapters = if @relationship.parent_chapter
      chapter_chain
    else
      []
    end
  end

  private

  def chapter_chain
    chain = [@relationship]
    current = @relationship
    while current.parent_chapter
      current = current.parent_chapter
      chain.unshift(current)
    end
    chain
  end
end
