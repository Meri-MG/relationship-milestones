require "application_system_test_case"

class EndingReconciliationTest < ApplicationSystemTestCase
  test "end chapter button is visible on dashboard for active relationship" do
    # Given I have an active relationship
    rel = relationships(:active_couple)
    visit relationship_path(rel)
    # When I visit the dashboard
    visit root_path
    # Then I should see the option to end the chapter
    assert_text "End this chapter"
  end

  test "ended relationship shows new chapter prompt on dashboard" do
    # Given I have an ended relationship
    ended = relationships(:ended_chapter)
    visit relationship_path(ended)
    # When I visit the dashboard
    visit root_path
    # Then I should see a prompt to begin a new chapter
    assert_text "Begin a new chapter"
  end

  test "ended relationship timeline shows muted ended state" do
    # Given I have an ended relationship
    ended = relationships(:ended_chapter)
    # When I visit the timeline
    visit relationship_path(ended)
    # Then I should see the ended state indicator
    assert_text "Chapter ended"
  end

  test "insights page renders for relationship with multiple chapters" do
    # Given I have a child chapter (relationship with chapter history)
    child = relationships(:child_chapter)
    visit relationship_path(child)
    # When I visit the insights page
    visit relationship_insights_path(child)
    # Then I should see the chapter comparison section
    assert_text "Between chapters"
  end

  test "insights page renders without chapters section for single chapter" do
    # Given I have a single-chapter relationship
    rel = relationships(:active_couple)
    visit relationship_path(rel)
    # When I visit the insights page
    visit relationship_insights_path(rel)
    # Then I should not see the chapter comparison section
    assert_no_text "Between chapters"
  end

  test "timeline for child chapter shows chapter separator" do
    # Given I have a child chapter with a milestone
    child = relationships(:child_chapter)
    child.milestones.create!(title: "New start moment", occurred_on: Date.today,
                              milestone_type: "first")
    # When I visit the timeline
    visit relationship_path(child)
    # Then I should see the archived chapter indicator
    assert_text(/archived/i)
    child.milestones.destroy_all
  end
end
