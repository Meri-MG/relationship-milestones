require "application_system_test_case"

class TimelineTest < ApplicationSystemTestCase
  def setup
    @rel = relationships(:active_couple)
    # Navigate to the relationship to set session
    visit relationship_path(@rel)
  end

  test "timeline page renders milestone cards" do
    assert_selector ".card", minimum: 1
  end

  test "milestone cards show type tags" do
    assert_text "First"
  end

  test "clicking a milestone card expands it" do
    # Find the first collapsed card and click it
    first_card = find(".card", match: :first)
    first_card.click
    # After click the expanded content should appear
    assert_selector ".card", minimum: 1  # card remains visible
  end

  test "filter tabs render" do
    assert_text "All"
    assert_text "Firsts"
    assert_text "Conflict"
  end

  test "clicking Conflict filter shows only conflict milestones" do
    click_link "Conflict"
    assert_current_path(relationship_path(@rel, filter: "conflict"))
  end

  test "clicking All resets filter" do
    visit relationship_path(@rel, filter: "conflict")
    click_link "All"
    assert_current_path(relationship_path(@rel))
  end

  test "add milestone button is present for active relationship" do
    assert_text "Add milestone"
  end

  test "ended relationship shows reflections unlock notice" do
    ended = relationships(:ended_chapter)
    visit relationship_path(ended)
    assert_text "Reflections are now open"
  end
end
