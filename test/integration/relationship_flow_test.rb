require "test_helper"

# Full user-journey integration tests.
# Each test uses the actual HTTP stack (routing → controller → view).
class RelationshipFlowTest < ActionDispatch::IntegrationTest

  # ── Onboarding flow ──────────────────────────────────────────

  test "visitor sees onboarding on root path" do
    get root_path
    assert_response :success
    assert_match(/space for your story/i, response.body)
  end

  test "visitor can create a relationship and is redirected to timeline" do
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: {
        relationship: { title: "A New Story", mode: "solo", began_on: Date.today }
      }
    end
    assert_redirected_to relationship_path(Relationship.last)
    follow_redirect!
    assert_response :success
    assert_match(/A New Story/, response.body)
  end

  test "after creating relationship, dashboard shows it" do
    post relationships_path, params: {
      relationship: { title: "My Chapter", mode: "couple", began_on: 3.months.ago.to_date }
    }
    get root_path
    assert_response :success
    assert_match(/My Chapter/, response.body)
  end

  test "invalid relationship creation re-renders form" do
    post relationships_path, params: {
      relationship: { title: "", mode: "solo", began_on: Date.today }
    }
    assert_response :unprocessable_entity
    assert_match(/form/i, response.body)
  end

  # ── Timeline & milestone flow ─────────────────────────────────

  test "user can view timeline" do
    rel = relationships(:active_couple)
    get relationship_path(rel)
    assert_response :success
    assert_match(/Timeline|timeline/i, response.body)
  end

  test "user can filter timeline by type" do
    rel = relationships(:active_couple)
    get relationship_path(rel, filter: "conflict")
    assert_response :success
  end

  test "user can access add milestone form" do
    rel = relationships(:active_couple)
    # Must have relationship in session first
    get relationship_path(rel)
    get new_relationship_milestone_path(rel)
    assert_response :success
  end

  test "user can add a milestone and see it on timeline" do
    rel = relationships(:active_couple)
    get relationship_path(rel)  # sets session
    assert_difference "Milestone.count", 1 do
      post relationship_milestones_path(rel), params: {
        milestone: { title: "A quiet moment", occurred_on: Date.today,
                     milestone_type: "growth", emotional_intensity: 5,
                     emotional_tags: ["joy"] }
      }
    end
    assert_redirected_to relationship_path(rel)
    follow_redirect!
    assert_match(/A quiet moment/, response.body)
  end

  test "user can view a milestone detail page" do
    rel  = relationships(:active_couple)
    m    = milestones(:first_meeting)
    get relationship_path(rel)
    get relationship_milestone_path(rel, m)
    assert_response :success
    assert_match(/The night we first talked/, response.body)
  end

  test "user can edit a milestone" do
    rel = relationships(:active_couple)
    m   = milestones(:growth_one)
    get relationship_path(rel)
    patch relationship_milestone_path(rel, m), params: {
      milestone: { title: "Revised growth", occurred_on: m.occurred_on,
                   milestone_type: "growth" }
    }
    assert_redirected_to relationship_path(rel)
    assert_equal "Revised growth", m.reload.title
  end

  test "user can delete a milestone" do
    rel = relationships(:active_couple)
    m   = rel.milestones.create!(title: "Temp", occurred_on: Date.today,
                                  milestone_type: "custom")
    get relationship_path(rel)
    assert_difference "Milestone.count", -1 do
      delete relationship_milestone_path(rel, m)
    end
    assert_redirected_to relationship_path(rel)
  end

  # ── Reflections flow ─────────────────────────────────────────

  test "user can view reflections page" do
    rel = relationships(:active_couple)
    get relationship_path(rel)
    get relationship_reflections_path(rel)
    assert_response :success
    assert_match(/Sit with it/i, response.body)
  end

  test "user can create a free-form reflection" do
    rel = relationships(:active_couple)
    get relationship_path(rel)
    assert_difference "Reflection.count", 1 do
      post relationship_reflections_path(rel), params: {
        reflection: { content: "An honest thought.", prompt_type: "open" }
      }
    end
    assert_redirected_to relationship_reflections_path(rel)
  end

  test "user can delete a reflection" do
    rel = relationships(:active_couple)
    r   = rel.reflections.create!(content: "To delete", prompt_type: "open")
    get relationship_path(rel)
    assert_difference "Reflection.count", -1 do
      delete relationship_reflection_path(rel, r)
    end
  end

  # ── Insights flow ────────────────────────────────────────────

  test "user can view insights page" do
    rel = relationships(:active_couple)
    get relationship_path(rel)
    get relationship_insights_path(rel)
    assert_response :success
    assert_match(/What the pattern shows/i, response.body)
  end

  test "insights page shows milestone counts" do
    rel = relationships(:active_couple)
    get relationship_path(rel)
    get relationship_insights_path(rel)
    assert_match(/Total moments/i, response.body)
  end

  # ── Ending flow ──────────────────────────────────────────────

  test "user can end a chapter" do
    rel = Relationship.create!(title: "Temp Chapter", mode: "solo", status: "active")
    get relationship_path(rel)
    patch end_chapter_relationship_path(rel)
    assert_redirected_to relationship_path(rel)
    assert_equal "ended", rel.reload.status
    rel.milestones.delete_all
    rel.destroy
  end

  test "ended timeline shows reflections unlock notice" do
    rel = relationships(:ended_chapter)
    get relationship_path(rel)
    assert_response :success
    assert_match(/Reflections are now open/, response.body)
  end

  # ── Reconciliation (new chapter) flow ────────────────────────

  test "user can begin a new chapter from an ended relationship" do
    rel = relationships(:ended_chapter)
    get relationship_path(rel)
    assert_difference "Relationship.count", 1 do
      post new_chapter_relationship_path(rel)
    end
    child = Relationship.last
    assert_equal rel.id, child.parent_chapter_id
    assert_redirected_to relationship_path(child)
  end

  test "new chapter redirects to new relationship timeline" do
    rel = relationships(:ended_chapter)
    get relationship_path(rel)
    post new_chapter_relationship_path(rel)
    child = Relationship.last
    follow_redirect!
    assert_match(/New Beginning|A Past Chapter/, response.body)
  end

  # ── Application-level error paths ────────────────────────────

  test "accessing milestone without relationship session redirects to root" do
    get new_relationship_milestone_path(0)
    assert_redirected_to root_path
  end

  test "accessing reflections without relationship session redirects to root" do
    get relationship_reflections_path(0)
    assert_redirected_to root_path
  end

  test "accessing insights without relationship session redirects to root" do
    get relationship_insights_path(0)
    assert_redirected_to root_path
  end
end
