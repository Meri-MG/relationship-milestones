require "application_system_test_case"

class MilestoneFormTest < ApplicationSystemTestCase
  def setup
    @rel = relationships(:active_couple)
    visit relationship_path(@rel)
  end

  test "add milestone link goes to new milestone form" do
    # Given I am on the timeline page
    # When I click the add milestone link
    click_link "Add milestone"
    # Then I should see the milestone type selection step
    assert_text "What kind of moment was this?"
  end

  test "step 1 shows all milestone types" do
    # Given I am on the new milestone form
    visit new_relationship_milestone_path(@rel)
    # Then I should see all available milestone types
    assert_text "First"
    assert_text "Funny threshold"
    assert_text "Conflict"
    assert_text "Growth"
    assert_text "Transition"
    assert_text "Custom"
  end

  test "selecting a type and continuing moves to step 2" do
    # Given I am on the new milestone form
    visit new_relationship_milestone_path(@rel)
    # When I select a milestone type and continue
    find("label", text: /Growth/).click
    first(:button, "Continue").click
    # Then I should see the details form with a title field
    assert_selector "input[name='milestone[title]']"
  end

  test "step 2 shows title, date, description fields" do
    # Given I have selected a milestone type and moved to step 2
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Growth/).click
    first(:button, "Continue").click
    # Then I should see title, date, and description fields
    assert_selector "input[name='milestone[title]']"
    assert_selector "input[type='date']"
    assert_selector "textarea[name='milestone[description]']"
  end

  test "step 2 shows emotional tag checkboxes" do
    # Given I have selected a milestone type and moved to step 2
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Growth/).click
    first(:button, "Continue").click
    # Then I should see emotional tag options
    assert_text "joy"
    assert_text "tenderness"
  end

  test "step 2 shows intensity slider" do
    # Given I have selected a milestone type and moved to step 2
    visit new_relationship_milestone_path(@rel)
    find("label", text: /First/).click
    first(:button, "Continue").click
    # Then I should see an emotional intensity slider
    assert_selector "input[type='range']"
  end

  test "completing all steps and submitting creates a milestone" do
    # Given I am on the new milestone form
    visit new_relationship_milestone_path(@rel)
    # When I complete all three steps
    find("label", text: /Growth/).click
    first(:button, "Continue").click
    fill_in "milestone[title]", with: "A meaningful shift"
    first(:button, "Continue").click
    # Then I should see the perspectives step
    assert_text "perspective"
    # When I submit the form
    click_button "Record this moment"
    # Then the milestone should be created and visible
    assert_text "A meaningful shift"
  end

  test "back button returns to previous step" do
    # Given I have moved to step 2
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Custom/).click
    first(:button, "Continue").click
    assert_selector "input[name='milestone[title]']"
    # When I click the back button
    first(:button, "Back").click
    # Then I should return to the type selection step
    assert_text "What kind of moment was this?"
  end

  test "conflict type shows repair notes section in step 3" do
    # Given I have selected the conflict type and filled in details
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Conflict/).click
    first(:button, "Continue").click
    fill_in "milestone[title]", with: "A hard moment"
    fill_in "milestone[occurred_on]", with: Date.today.strftime("%Y-%m-%d")
    # When I continue to step 3
    first(:button, "Continue").click
    # Then I should see the repair notes section
    assert_text(/repair notes/i)
  end

  test "close button returns to timeline" do
    # Given I am on the new milestone form
    visit new_relationship_milestone_path(@rel)
    # When I click the close button
    find("a.btn-icon[href='#{relationship_path(@rel)}']").click
    # Then I should return to the timeline
    assert_current_path(relationship_path(@rel))
  end
end
