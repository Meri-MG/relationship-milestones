class DashboardController < ApplicationController
  def index
    if @relationship
      @recent_milestones  = @relationship.milestones.recent.limit(3)
      @latest_reflection  = @relationship.reflections.recent.first
      @emotional_summary  = compute_emotional_summary
    end
  end

  private

  def compute_emotional_summary
    return {} unless @relationship

    counts = @relationship.milestones.unscope(:order).group(:milestone_type).count
    total  = counts.values.sum.to_f

    {
      joy:        pct(counts["first"].to_i + counts["funny"].to_i, total),
      growth:     pct(counts["growth"].to_i, total),
      tension:    pct(counts["conflict"].to_i, total),
      stability:  pct(counts["transition"].to_i, total),
    }
  end

  def pct(n, total)
    total.zero? ? 0 : ((n / total) * 100).round
  end
end
