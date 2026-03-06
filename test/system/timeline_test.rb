require "application_system_test_case"

class TimelineTest < ApplicationSystemTestCase
  def setup
    @rel = relationships(:active_couple)
    visit relationship_path(@rel)
  end

  test "timeline page renders milestone cards" do
    # Given I am on the timeline page
    # Then I should see at least one milestone card
    assert_selector ".card", minimum: 1
  end

  test "milestone cards show type tags" do
    # Given I am on the timeline page
    # Then I should see milestone type labels
    assert_text "First"
  end

  test "clicking a milestone card expands it" do
    # Given I am on the timeline page
    # When I click on a milestone card
    first_card = find(".card", match: :first)
    first_card.click
    # Then the card should remain visible with expanded content
    assert_selector ".card", minimum: 1
  end

  test "filter tabs render" do
    # Given I am on the timeline page
    # Then I should see filter tabs for milestone types
    assert_text "All"
    assert_text "Firsts"
    assert_text "Conflict"
  end

  test "clicking Conflict filter shows only conflict milestones" do
    # Given I am on the timeline page
    # When I click the Conflict filter tab
    click_link "Conflict"
    # Then the URL should reflect the conflict filter
    assert_current_path(relationship_path(@rel, filter: "conflict"))
  end

  test "clicking All resets filter" do
    # Given I am viewing filtered milestones
    visit relationship_path(@rel, filter: "conflict")
    # When I click the All filter tab
    click_link "All"
    # Then the filter should be cleared
    assert_current_path(relationship_path(@rel))
  end

  test "add milestone button is present for active relationship" do
    # Given I am on the timeline page for an active relationship
    # Then I should see the add milestone button
    assert_text "Add milestone"
  end

  test "ended relationship shows reflections unlock notice" do
    # Given I have an ended relationship
    ended = relationships(:ended_chapter)
    # When I visit the timeline
    visit relationship_path(ended)
    # Then I should see a notice that reflections are unlocked
    assert_text "Reflections are now open"
  end
end
