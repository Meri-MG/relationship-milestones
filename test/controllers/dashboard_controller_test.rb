require "test_helper"

class DashboardControllerTest < ActionController::TestCase
  def setup
    @couple = relationships(:active_couple)
    @solo   = relationships(:active_solo)
    @ended  = relationships(:ended_chapter)
    @child  = relationships(:child_chapter)
  end

  # ── Without a relationship in session ────────────────────────

  test "GET index renders onboarding when no session" do
    get :index
    assert_response :success
    assert_match(/space for your story/i, response.body)
  end

  test "GET index renders onboarding when session id is stale" do
    session[:relationship_id] = 0
    get :index
    assert_response :success
    assert_match(/space for your story/i, response.body)
  end

  # ── With a relationship in session ───────────────────────────

  test "GET index renders dashboard for active relationship" do
    session[:relationship_id] = @couple.id
    get :index
    assert_response :success
    assert_match(/Our Story Together/, response.body)
  end

  test "GET index shows relationship health section" do
    session[:relationship_id] = @couple.id
    get :index
    assert_select "h2", text: /Relationship Health/i
  end

  test "GET index shows your journey section" do
    session[:relationship_id] = @couple.id
    get :index
    assert_select "h2", text: /Your Journey/i
  end

  test "GET index shows active badge for active relationship" do
    session[:relationship_id] = @couple.id
    get :index
    assert_match(/Active/, response.body)
  end

  test "GET index shows ended badge for ended relationship" do
    session[:relationship_id] = @ended.id
    get :index
    assert_match(/Ended/, response.body)
  end

  test "GET index shows new chapter CTA for ended relationship" do
    session[:relationship_id] = @ended.id
    get :index
    assert_match(/Begin a new chapter/, response.body)
  end

  test "GET index shows chapter number when greater than one" do
    session[:relationship_id] = @child.id
    get :index
    assert_match(/Chapter 2/, response.body)
  end

  test "GET index computes zero emotional summary gracefully when no milestones" do
    rel = Relationship.create!(title: "Empty", mode: "solo", status: "active")
    session[:relationship_id] = rel.id
    get :index
    assert_response :success
    rel.destroy
  end

  test "GET index shows solo relationship" do
    session[:relationship_id] = @solo.id
    get :index
    assert_response :success
    assert_match(/My Solo Story/, response.body)
  end
end
