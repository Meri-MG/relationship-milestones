require "application_system_test_case"

class MilestoneFormTest < ApplicationSystemTestCase
  def setup
    @rel = relationships(:active_couple)
    visit relationship_path(@rel)
  end

  test "add milestone link goes to new milestone form" do
    click_link "Add milestone"
    assert_text "Choose a type"
  end

  test "step 1 shows all milestone types" do
    visit new_relationship_milestone_path(@rel)
    assert_text "First"
    assert_text "Funny threshold"
    assert_text "Conflict"
    assert_text "Growth"
    assert_text "Transition"
    assert_text "Custom"
  end

  test "selecting a type and continuing moves to step 2" do
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Growth/).click
    click_button "Continue"
    assert_text "Add details"
  end

  test "step 2 shows title, date, description fields" do
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Growth/).click
    click_button "Continue"
    assert_selector "input[name='milestone[title]']"
    assert_selector "input[type='date']"
    assert_selector "textarea[name='milestone[description]']"
  end

  test "step 2 shows emotional tag checkboxes" do
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Growth/).click
    click_button "Continue"
    assert_text "joy"
    assert_text "tenderness"
  end

  test "step 2 shows intensity slider" do
    visit new_relationship_milestone_path(@rel)
    find("label", text: /First/).click
    click_button "Continue"
    assert_selector "input[type='range']"
  end

  test "completing all steps and submitting creates a milestone" do
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Growth/).click
    click_button "Continue"
    fill_in "milestone[title]", with: "A meaningful shift"
    click_button "Continue"
    assert_text "Perspectives"
    click_button "Record this moment"
    assert_text "A meaningful shift"
  end

  test "back button returns to previous step" do
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Custom/).click
    click_button "Continue"
    assert_text "Add details"
    click_button "Back"
    assert_text "Choose a type"
  end

  test "conflict type shows repair notes section in step 3" do
    visit new_relationship_milestone_path(@rel)
    find("label", text: /Conflict/).click
    click_button "Continue"
    fill_in "milestone[title]", with: "A hard moment"
    fill_in "milestone[occurred_on]", with: Date.today.strftime("%Y-%m-%d")
    click_button "Continue"
    assert_text(/repair notes/i)
  end

  test "close button returns to timeline" do
    visit new_relationship_milestone_path(@rel)
    find("a.btn-icon[href='#{relationship_path(@rel)}']").click
    assert_current_path(relationship_path(@rel))
  end
end
