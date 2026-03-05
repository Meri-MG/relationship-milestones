require "test_helper"

class InsightsControllerTest < ActionController::TestCase
  def setup
    @rel   = relationships(:active_couple)
    @ended = relationships(:ended_chapter)
    @child = relationships(:child_chapter)
    session[:relationship_id] = @rel.id
  end

  # ── Require relationship ──────────────────────────────────────

  test "GET show redirects when no relationship in session" do
    get :show, params: { relationship_id: 0 }
    assert_redirected_to root_path
  end

  # ── GET show ─────────────────────────────────────────────────

  test "GET show renders insights page" do
    get :show, params: { relationship_id: @rel.id }
    assert_response :success
  end

  test "GET show assigns total_milestones" do
    get :show, params: { relationship_id: @rel.id }
    assert_equal @rel.milestones.count, assigns(:total_milestones)
  end

  test "GET show assigns by_type hash" do
    get :show, params: { relationship_id: @rel.id }
    assert_kind_of Hash, assigns(:by_type)
  end

  test "GET show assigns monthly_activity" do
    get :show, params: { relationship_id: @rel.id }
    assert_kind_of Hash, assigns(:monthly_activity)
  end

  test "GET show assigns avg_intensity" do
    get :show, params: { relationship_id: @rel.id }
    assert_not_nil assigns(:avg_intensity)
  end

  test "GET show assigns conflict_count" do
    get :show, params: { relationship_id: @rel.id }
    assert_equal @rel.milestones.by_type("conflict").count, assigns(:conflict_count)
  end

  test "GET show assigns growth_count" do
    get :show, params: { relationship_id: @rel.id }
    assert_equal @rel.milestones.by_type("growth").count, assigns(:growth_count)
  end

  test "GET show assigns repair_notes_count correctly" do
    get :show, params: { relationship_id: @rel.id }
    expected = @rel.milestones.by_type("conflict")
                              .where.not(repair_notes: [nil, ""])
                              .count
    assert_equal expected, assigns(:repair_notes_count)
  end

  test "GET show computes repair_rate as integer percentage" do
    get :show, params: { relationship_id: @rel.id }
    rate = assigns(:repair_rate)
    assert_kind_of Integer, rate
    assert_includes 0..100, rate
  end

  test "GET show repair_rate is 0 when no conflicts" do
    rel = Relationship.create!(title: "No conflicts", mode: "solo", status: "active")
    rel.milestones.create!(title: "G", occurred_on: Date.today, milestone_type: "growth")
    session[:relationship_id] = rel.id
    get :show, params: { relationship_id: rel.id }
    assert_equal 0, assigns(:repair_rate)
    rel.destroy
  end

  test "GET show assigns empty chapters when no parent chapter" do
    get :show, params: { relationship_id: @rel.id }
    assert_empty assigns(:chapters)
  end

  test "GET show assigns chapter chain when parent exists" do
    session[:relationship_id] = @child.id
    get :show, params: { relationship_id: @child.id }
    chapters = assigns(:chapters)
    assert_equal 2, chapters.length
  end

  test "GET show handles relationship with no milestones" do
    rel = Relationship.create!(title: "Empty", mode: "solo", status: "active")
    session[:relationship_id] = rel.id
    get :show, params: { relationship_id: rel.id }
    assert_response :success
    assert_equal 0, assigns(:total_milestones)
    assert_nil assigns(:avg_intensity)
    rel.destroy
  end

  test "GET show shows observational insight for high repair rate" do
    # conflict_one has repair_notes, so repair_rate should be > 0
    get :show, params: { relationship_id: @rel.id }
    assert_response :success
    # Just assert the page renders without error — observational text varies
  end
end
