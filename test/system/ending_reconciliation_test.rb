require "application_system_test_case"

class EndingReconciliationTest < ApplicationSystemTestCase
  test "end chapter button is visible on dashboard for active relationship" do
    rel = relationships(:active_couple)
    visit relationship_path(rel)
    visit root_path
    assert_text "End this chapter"
  end

  test "ended relationship shows new chapter prompt on dashboard" do
    ended = relationships(:ended_chapter)
    visit relationship_path(ended)
    visit root_path
    assert_text "Begin a new chapter"
  end

  test "ended relationship timeline shows muted ended state" do
    ended = relationships(:ended_chapter)
    visit relationship_path(ended)
    assert_text "Chapter ended"
  end

  test "insights page renders for relationship with multiple chapters" do
    child = relationships(:child_chapter)
    visit relationship_path(child)
    visit relationship_insights_path(child)
    assert_text "Between chapters"
  end

  test "insights page renders without chapters section for single chapter" do
    rel = relationships(:active_couple)
    visit relationship_path(rel)
    visit relationship_insights_path(rel)
    # No 'Between chapters' section for single chapter relationship
    assert_no_text "Between chapters"
  end

  test "timeline for child chapter shows chapter separator" do
    child = relationships(:child_chapter)
    # Seed a milestone for the child chapter
    child.milestones.create!(title: "New start moment", occurred_on: Date.today,
                              milestone_type: "first")
    visit relationship_path(child)
    assert_text(/archived/i)
    child.milestones.destroy_all
  end
end
