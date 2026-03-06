class DashboardController < ApplicationController
  def index
    if @relationship
      @recent_milestones  = @relationship.milestones.recent.limit(3)
      @latest_reflection  = @relationship.reflections.recent.first
      @greeting           = "#{time_greeting}, #{person_name(@relationship)}."
      @days_together      = days_together(@relationship.began_on)
      @monthly_insight    = compute_monthly_insight
      @relationship_health = compute_relationship_health
    end
  end

  private

  def compute_monthly_insight
    now        = Date.today
    this_month = @relationship.milestones.where(occurred_on: (now - 30)..now)
    last_month = @relationship.milestones.where(occurred_on: (now - 60)..(now - 30))

    this_count  = this_month.count
    last_count  = last_month.count
    growth_pct  = this_month.where(milestone_type: "growth").count.to_f / [ this_count, 1 ].max

    headline, body = if growth_pct >= 0.4
      [
        "Growth was the dominant theme this month.",
        "More than a third of your moments this month pointed toward understanding and change. That's not nothing."
      ]
    elsif this_count > last_count && last_count > 0
      [
        "More moments captured than last month.",
        "You recorded #{this_count} moments this month, up from #{last_count}. Something is being paid attention to."
      ]
    elsif @relationship.reflections.where(created_at: (now - 30)..now).count >
          @relationship.reflections.where(created_at: (now - 60)..(now - 30)).count
      [
        "Moments of vulnerability increased this month.",
        "You've been reflecting more than usual. That kind of attention often means something is shifting."
      ]
    else
      [
        "Your story continues, quietly.",
        "#{this_count > 0 ? "#{this_count} moment#{'s' if this_count != 1} recorded this month." : "No new moments this month."} Every chapter has its quieter passages."
      ]
    end

    { headline: headline, body: body, generated_at: now }
  end

  def compute_relationship_health
    milestones = @relationship.milestones.to_a
    total      = milestones.size.to_f

    return default_health if total.zero?

    positive   = milestones.count { |m| %w[first funny growth].include?(m.milestone_type) }
    growth_n   = milestones.count { |m| m.milestone_type == "growth" }
    conflicts  = milestones.select { |m| m.milestone_type == "conflict" }
    repaired   = conflicts.count { |m| m.repair_notes.present? }

    connection_pct = (positive / total * 100).round
    growth_pct     = (growth_n / total * 100).round
    repair_rate    = conflicts.any? ? (repaired.to_f / conflicts.size * 100).round : nil

    {
      connection: {
        score: connection_pct,
        label: connection_pct >= 60 ? "High" : connection_pct >= 35 ? "Good" : "Building"
      },
      growth: {
        score: growth_pct,
        label: growth_pct >= 30 ? "Growing" : growth_pct >= 15 ? "Steady" : "Early"
      },
      conflict_resolution: {
        score: repair_rate,
        label: repair_rate.nil? ? "No conflicts" : repair_rate >= 60 ? "Improving" : repair_rate >= 30 ? "Learning" : "None"
      },
      quote: derive_health_quote(connection_pct, growth_pct, repair_rate)
    }
  end

  def derive_health_quote(connection, growth, repair_rate)
    if connection >= 60 && growth >= 25
      "A relationship where joy and growth coexist is a rare and careful thing."
    elsif repair_rate&.>= 50
      "The willingness to repair is itself a form of love."
    elsif growth >= 30
      "Something is always changing here. That's not a warning — it's a sign of life."
    else
      "Every archive begins somewhere. Yours is still being written."
    end
  end

  def default_health
    {
      connection:          { score: 0, label: "Building" },
      growth:              { score: 0, label: "Early" },
      conflict_resolution: { score: nil, label: "No conflicts" },
      quote:               "Every archive begins somewhere. Yours is still being written."
    }
  end

  # Delegate helper methods to ApplicationHelper
  def time_greeting;       view_context.time_greeting;                  end
  def person_name(r);      view_context.person_name(r);                 end
  def days_together(date); view_context.days_together(date);            end
end
