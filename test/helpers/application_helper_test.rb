require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  # ── milestone_type_bg ─────────────────────────────────────────

  test "milestone_type_bg returns sage classes for first" do
    result = milestone_type_bg("first")
    assert_includes result, "sage"
  end

  test "milestone_type_bg returns warm classes for funny" do
    result = milestone_type_bg("funny")
    assert_includes result, "warm"
  end

  test "milestone_type_bg returns rose classes for conflict" do
    result = milestone_type_bg("conflict")
    assert_includes result, "rose"
  end

  test "milestone_type_bg returns sage classes for growth" do
    result = milestone_type_bg("growth")
    assert_includes result, "sage"
  end

  test "milestone_type_bg returns slate classes for transition" do
    result = milestone_type_bg("transition")
    assert_includes result, "slate"
  end

  test "milestone_type_bg returns warm classes for ending" do
    result = milestone_type_bg("ending")
    assert_includes result, "warm"
  end

  test "milestone_type_bg returns warm classes for custom" do
    result = milestone_type_bg("custom")
    assert_includes result, "warm"
  end

  test "milestone_type_bg returns default for unknown type" do
    result = milestone_type_bg("unknown_xyz")
    assert_includes result, "warm"
  end

  test "milestone_type_bg accepts symbol" do
    result = milestone_type_bg(:conflict)
    assert_includes result, "rose"
  end

  # ── milestone_node_class ──────────────────────────────────────

  test "milestone_node_class returns active class for first" do
    assert_equal "timeline-node-active", milestone_node_class("first")
  end

  test "milestone_node_class returns funny class for funny" do
    assert_equal "timeline-node-funny", milestone_node_class("funny")
  end

  test "milestone_node_class returns conflict class for conflict" do
    assert_equal "timeline-node-conflict", milestone_node_class("conflict")
  end

  test "milestone_node_class returns growth class for growth" do
    assert_equal "timeline-node-growth", milestone_node_class("growth")
  end

  test "milestone_node_class returns transition class for transition" do
    assert_equal "timeline-node-transition", milestone_node_class("transition")
  end

  test "milestone_node_class returns default for ending" do
    assert_equal "timeline-node", milestone_node_class("ending")
  end

  test "milestone_node_class returns default for unknown" do
    assert_equal "timeline-node", milestone_node_class("unknown")
  end

  # ── intensity_label ──────────────────────────────────────────

  test "intensity_label returns Gentle for 1" do
    assert_equal "Gentle", intensity_label(1)
  end

  test "intensity_label returns Gentle for 3" do
    assert_equal "Gentle", intensity_label(3)
  end

  test "intensity_label returns Moderate for 4" do
    assert_equal "Moderate", intensity_label(4)
  end

  test "intensity_label returns Moderate for 6" do
    assert_equal "Moderate", intensity_label(6)
  end

  test "intensity_label returns Strong for 7" do
    assert_equal "Strong", intensity_label(7)
  end

  test "intensity_label returns Strong for 8" do
    assert_equal "Strong", intensity_label(8)
  end

  test "intensity_label returns Intense for 9" do
    assert_equal "Intense", intensity_label(9)
  end

  test "intensity_label returns Intense for 10" do
    assert_equal "Intense", intensity_label(10)
  end

  test "intensity_label returns dash for nil" do
    assert_equal "–", intensity_label(nil)
  end

  # ── time_ago_label ───────────────────────────────────────────

  test "time_ago_label returns dash for nil" do
    assert_equal "–", time_ago_label(nil)
  end

  test "time_ago_label returns Today for today" do
    assert_equal "Today", time_ago_label(Date.today)
  end

  test "time_ago_label returns Yesterday for 1 day ago" do
    assert_equal "Yesterday", time_ago_label(1.day.ago)
  end

  test "time_ago_label returns days ago for 2-29 days" do
    assert_match(/\d+ days ago/, time_ago_label(10.days.ago))
  end

  test "time_ago_label returns months ago for 30-364 days" do
    assert_match(/\d+ months ago/, time_ago_label(60.days.ago))
  end

  test "time_ago_label returns years ago for 365+ days" do
    assert_match(/years ago/, time_ago_label(400.days.ago))
  end

  # ── format_date_long ─────────────────────────────────────────

  test "format_date_long formats correctly" do
    date = Date.new(2024, 6, 15)
    assert_equal "15 June 2024", format_date_long(date)
  end

  test "format_date_long returns dash for nil" do
    assert_equal "–", format_date_long(nil)
  end

  # ── format_date_short ────────────────────────────────────────

  test "format_date_short formats correctly" do
    date = Date.new(2024, 6, 15)
    assert_equal "Jun 15, 2024", format_date_short(date)
  end

  test "format_date_short returns dash for nil" do
    assert_equal "–", format_date_short(nil)
  end
end
