require "application_system_test_case"

class ReflectionsTest < ApplicationSystemTestCase
  def setup
    @rel = relationships(:active_couple)
    visit relationship_path(@rel)
    visit relationship_reflections_path(@rel)
  end

  test "reflections page renders" do
    # Given I am on the reflections page
    # Then I should see the reflections heading
    assert_text "Sit with it"
  end

  test "guided prompts are shown" do
    # Given I am on the reflections page
    # Then I should see all three guided prompts
    assert_text "When did I feel most myself?"
    assert_text "What patterns repeat?"
    assert_text "What will I carry forward?"
  end

  test "clicking a prompt card expands inline editor" do
    # Given I am on the reflections page
    # When I click on a guided prompt card
    find("div[data-reflection-prompt-key-param='most_myself']", match: :first).click
    # Then I should see a textarea to write a reflection
    assert_selector "textarea", minimum: 1
  end

  test "free-form text area is present" do
    # Given I am on the reflections page
    # Then I should see a free-form reflection textarea
    assert_selector "textarea[name='reflection[content]']"
  end

  test "user can submit a free-form reflection" do
    # Given I am on the reflections page
    # When I fill in a free-form reflection and submit
    fill_in "reflection[content]", with: "An open thought for today."
    click_button "Save"
    # Then my reflection should be saved and displayed
    assert_text "An open thought for today."
  end

  test "past reflections sidebar shows existing reflections" do
    # Given I am on the reflections page with existing reflections
    # Then I should see previously saved reflections
    assert_text "quiet moments"
  end

  test "ended relationship shows reflection unlock note" do
    # Given I have an ended relationship
    ended = relationships(:ended_chapter)
    visit relationship_path(ended)
    # When I visit the reflections page
    visit relationship_reflections_path(ended)
    # Then I should see a note about the chapter being ended
    assert_text(/chapter ended/i)
  end
end
