require "test_helper"

class MilestonesControllerTest < ActionController::TestCase
  def setup
    @rel     = relationships(:active_couple)
    @ended   = relationships(:ended_chapter)
    @first   = milestones(:first_meeting)
    @conflict = milestones(:conflict_one)
    session[:relationship_id] = @rel.id
  end

  def valid_params
    { title: "A new moment", occurred_on: Date.today, milestone_type: "growth",
      description: "Something shifted.", emotional_intensity: 5, emotional_tags: [] }
  end

  # ── GET new ──────────────────────────────────────────────────

  test "GET new renders form on step 1" do
    get :new, params: { relationship_id: @rel.id }
    assert_response :success
    assert_equal 1, assigns(:step)
  end

  test "GET new with step param sets step" do
    get :new, params: { relationship_id: @rel.id, step: 2 }
    assert_response :success
    assert_equal 2, assigns(:step)
  end

  test "GET new redirects if no relationship in session" do
    get :new, params: { relationship_id: 0 }
    assert_redirected_to root_path
  end

  # ── POST create ──────────────────────────────────────────────

  test "POST create with valid params creates milestone" do
    assert_difference "Milestone.count", 1 do
      post :create, params: { relationship_id: @rel.id, milestone: valid_params }
    end
  end

  test "POST create redirects to relationship on success" do
    post :create, params: { relationship_id: @rel.id, milestone: valid_params }
    assert_redirected_to relationship_path(@rel)
  end

  test "POST create sets notice on success" do
    post :create, params: { relationship_id: @rel.id, milestone: valid_params }
    assert_equal "A moment has been recorded.", flash[:notice]
  end

  test "POST create with invalid params does not create milestone" do
    assert_no_difference "Milestone.count" do
      post :create, params: { relationship_id: @rel.id,
                               milestone: { title: "", occurred_on: nil, milestone_type: "custom" } }
    end
  end

  test "POST create with invalid params renders new with unprocessable_entity" do
    post :create, params: { relationship_id: @rel.id,
                             milestone: { title: "", occurred_on: nil, milestone_type: "custom" } }
    assert_response :unprocessable_entity
    assert_template :new
  end

  test "POST create invalid sets step to 2" do
    post :create, params: { relationship_id: @rel.id,
                             milestone: { title: "", occurred_on: nil, milestone_type: "custom" } }
    assert_equal 2, assigns(:step)
  end

  test "POST create responds with turbo_stream format" do
    post :create, params: { relationship_id: @rel.id, milestone: valid_params },
                  format: :turbo_stream
    assert_response :success
  end

  test "POST create redirects if no relationship" do
    post :create, params: { relationship_id: 0, milestone: valid_params }
    assert_redirected_to root_path
  end

  # ── GET show ─────────────────────────────────────────────────

  test "GET show renders milestone detail" do
    get :show, params: { relationship_id: @rel.id, id: @first.id }
    assert_response :success
    assert_match(@first.title, response.body)
  end

  test "GET show for conflict milestone shows repair section" do
    get :show, params: { relationship_id: @rel.id, id: @conflict.id }
    assert_response :success
    assert_match(/Repair notes/, response.body)
  end

  # ── GET edit ─────────────────────────────────────────────────

  test "GET edit renders edit form" do
    get :edit, params: { relationship_id: @rel.id, id: @first.id }
    assert_response :success
    assert_equal 2, assigns(:step)
  end

  # ── PATCH update ─────────────────────────────────────────────

  test "PATCH update with valid params updates milestone" do
    patch :update, params: { relationship_id: @rel.id, id: @first.id,
                              milestone: { title: "Updated title", occurred_on: Date.today,
                                           milestone_type: "first" } }
    assert_equal "Updated title", @first.reload.title
  end

  test "PATCH update redirects to relationship on success" do
    patch :update, params: { relationship_id: @rel.id, id: @first.id,
                              milestone: { title: "Updated", occurred_on: Date.today,
                                           milestone_type: "first" } }
    assert_redirected_to relationship_path(@rel)
  end

  test "PATCH update sets notice on success" do
    patch :update, params: { relationship_id: @rel.id, id: @first.id,
                              milestone: { title: "Updated", occurred_on: Date.today,
                                           milestone_type: "first" } }
    assert_equal "The milestone has been updated.", flash[:notice]
  end

  test "PATCH update with invalid params renders edit" do
    patch :update, params: { relationship_id: @rel.id, id: @first.id,
                              milestone: { title: "", occurred_on: nil, milestone_type: "first" } }
    assert_response :unprocessable_entity
    assert_template :edit
  end

  # ── DELETE destroy ────────────────────────────────────────────

  test "DELETE destroy removes milestone" do
    m = @rel.milestones.create!(title: "To delete", occurred_on: Date.today,
                                 milestone_type: "custom")
    assert_difference "Milestone.count", -1 do
      delete :destroy, params: { relationship_id: @rel.id, id: m.id }
    end
  end

  test "DELETE destroy redirects to relationship" do
    m = @rel.milestones.create!(title: "To delete", occurred_on: Date.today,
                                 milestone_type: "custom")
    delete :destroy, params: { relationship_id: @rel.id, id: m.id }
    assert_redirected_to relationship_path(@rel)
  end

  test "DELETE destroy sets notice" do
    m = @rel.milestones.create!(title: "To delete", occurred_on: Date.today,
                                 milestone_type: "custom")
    delete :destroy, params: { relationship_id: @rel.id, id: m.id }
    assert_equal "The milestone has been removed.", flash[:notice]
  end
end
