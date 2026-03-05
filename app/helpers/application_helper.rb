module ApplicationHelper
  # Return a Tailwind bg class for a milestone type
  def milestone_type_bg(type)
    {
      "first"      => "bg-sage-100 text-sage-700 border-sage-200",
      "funny"      => "bg-warm-200 text-ink-600 border-warm-300",
      "conflict"   => "bg-rose-100 text-rose-600 border-rose-200",
      "growth"     => "bg-sage-100 text-sage-700 border-sage-200",
      "transition" => "bg-slate-100 text-slate-600 border-slate-200",
      "ending"     => "bg-warm-200 text-ink-600 border-warm-300",
      "custom"     => "bg-warm-100 text-ink-500 border-warm-200",
    }.fetch(type.to_s, "bg-warm-100 text-ink-500 border-warm-200")
  end

  def milestone_node_class(type)
    {
      "first"      => "timeline-node-active",
      "funny"      => "timeline-node-funny",
      "conflict"   => "timeline-node-conflict",
      "growth"     => "timeline-node-growth",
      "transition" => "timeline-node-transition",
      "ending"     => "timeline-node",
    }.fetch(type.to_s, "timeline-node")
  end

  # Intensity label: 1-3 low, 4-6 mid, 7-10 high
  def intensity_label(value)
    case value.to_i
    when 1..3 then "Gentle"
    when 4..6 then "Moderate"
    when 7..8 then "Strong"
    when 9..10 then "Intense"
    else "–"
    end
  end

  # Duration helper
  def time_ago_label(date)
    return "–" unless date
    days = (Date.today - date.to_date).to_i
    return "Today"                      if days == 0
    return "Yesterday"                  if days == 1
    return "#{days} days ago"           if days < 30
    return "#{(days / 30.0).round} months ago" if days < 365
    "#{(days / 365.0).round(1)} years ago"
  end

  def format_date_long(date)
    date&.strftime("%-d %B %Y") || "–"
  end

  def format_date_short(date)
    date&.strftime("%b %-d, %Y") || "–"
  end
end
