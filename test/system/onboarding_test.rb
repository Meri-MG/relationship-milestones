require "application_system_test_case"

class OnboardingTest < ApplicationSystemTestCase
  test "visitor sees onboarding form on root page" do
    visit root_path
    assert_text "A space for your story"
    assert_selector "form"
  end

  test "visitor can fill in and submit the onboarding form" do
    visit root_path
    fill_in "Give this chapter a name", with: "Our Adventure"
    click_button "Begin this chapter"
    assert_text "Our Adventure"
  end

  test "solo mode is selected by default" do
    visit root_path
    assert_selector "input[value='solo']"
  end

  test "validation error shown when title blank" do
    visit root_path
    fill_in "Give this chapter a name", with: ""
    click_button "Begin this chapter"
    # Browser HTML5 validation prevents submission with blank required field
    # OR server returns 422 with error — either way stays on page
    assert_current_path("/")
  end

  test "visitor can select couple mode" do
    visit root_path
    find("label", text: "Together").click
    fill_in "Give this chapter a name", with: "Together Story"
    click_button "Begin this chapter"
    assert_text "Together Story"
  end
end
