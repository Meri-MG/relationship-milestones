require "application_system_test_case"

class OnboardingTest < ApplicationSystemTestCase
  test "visitor sees onboarding form on root page" do
    # Given I am a new visitor with no relationship
    # When I visit the root page
    visit root_path
    # Then I should see the onboarding form
    assert_text "A space for your story"
    assert_selector "form"
  end

  test "visitor can fill in and submit the onboarding form" do
    # Given I am on the onboarding page
    visit root_path
    # When I fill in the chapter name and submit
    fill_in "Give this chapter a name", with: "Our Adventure"
    click_button "Begin this chapter"
    # Then my relationship should be created and visible
    assert_text "Our Adventure"
  end

  test "solo mode is selected by default" do
    # Given I am on the onboarding page
    visit root_path
    # Then solo mode should be pre-selected
    assert_selector "input[value='solo']"
  end

  test "validation error shown when title blank" do
    # Given I am on the onboarding page
    visit root_path
    # When I submit the form with a blank title
    fill_in "Give this chapter a name", with: ""
    click_button "Begin this chapter"
    # Then I should see a validation error and the form should re-render
    assert_selector "form"
    assert_text "can't be blank"
  end

  test "visitor can select couple mode" do
    # Given I am on the onboarding page
    visit root_path
    # When I select couple mode and submit
    find("label", text: "Together").click
    fill_in "Give this chapter a name", with: "Together Story"
    click_button "Begin this chapter"
    # Then my relationship should be created in couple mode
    assert_text "Together Story"
  end
end
