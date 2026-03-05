require "application_system_test_case"

class ReflectionsTest < ApplicationSystemTestCase
  def setup
    @rel = relationships(:active_couple)
    visit relationship_path(@rel)
    visit relationship_reflections_path(@rel)
  end

  test "reflections page renders" do
    assert_text "Sit with it"
  end

  test "guided prompts are shown" do
    assert_text "When did I feel most myself?"
    assert_text "What patterns repeat?"
    assert_text "What will I carry forward?"
  end

  test "clicking a prompt card expands inline editor" do
    find("div[data-reflection-prompt-key-param='most_myself']", match: :first).click
    assert_selector "textarea", minimum: 1
  end

  test "free-form text area is present" do
    assert_selector "textarea[name='reflection[content]']"
  end

  test "user can submit a free-form reflection" do
    fill_in "reflection[content]", with: "An open thought for today."
    click_button "Save"
    assert_text "An open thought for today."
  end

  test "past reflections sidebar shows existing reflections" do
    assert_text "quiet moments"  # from fixture: open_reflection
  end

  test "ended relationship shows reflection unlock note" do
    ended = relationships(:ended_chapter)
    visit relationship_path(ended)
    visit relationship_reflections_path(ended)
    assert_text(/chapter ended/i)
  end
end
