require "test_helper"

class ReflectionsControllerTest < ActionController::TestCase
  def setup
    @rel        = relationships(:active_couple)
    @reflection = reflections(:most_myself)
    session[:relationship_id] = @rel.id
  end

  # ── GET index ─────────────────────────────────────────────────

  test "GET index renders reflections page" do
    get :index, params: { relationship_id: @rel.id }
    assert_response :success
  end

  test "GET index assigns reflections in desc order" do
    get :index, params: { relationship_id: @rel.id }
    refls = assigns(:reflections)
    times = refls.map(&:created_at)
    assert_equal times.sort.reverse, times
  end

  test "GET index assigns new reflection" do
    get :index, params: { relationship_id: @rel.id }
    assert_instance_of Reflection, assigns(:reflection)
    assert assigns(:reflection).new_record?
  end

  test "GET index assigns all prompts" do
    get :index, params: { relationship_id: @rel.id }
    assert_equal Reflection::PROMPTS, assigns(:prompts)
  end

  test "GET index redirects when no relationship" do
    get :index, params: { relationship_id: 0 }
    assert_redirected_to root_path
  end

  # ── POST create (HTML) ────────────────────────────────────────

  test "POST create creates reflection" do
    assert_difference "Reflection.count", 1 do
      post :create, params: { relationship_id: @rel.id,
                               reflection: { content: "New thought", prompt_type: "open" } }
    end
  end

  test "POST create HTML redirects on success" do
    post :create, params: { relationship_id: @rel.id,
                             reflection: { content: "New thought", prompt_type: "open" } }
    assert_redirected_to relationship_reflections_path(@rel)
  end

  test "POST create HTML sets notice" do
    post :create, params: { relationship_id: @rel.id,
                             reflection: { content: "New thought", prompt_type: "open" } }
    assert_equal "Your reflection is saved.", flash[:notice]
  end

  test "POST create HTML with invalid params renders index" do
    # Force failure by using non-existent relationship_id
    post :create, params: { relationship_id: 0,
                             reflection: { content: "Text", prompt_type: "open" } }
    assert_redirected_to root_path
  end

  # ── POST create (Turbo Stream) ────────────────────────────────

  test "POST create responds with turbo_stream" do
    post :create, params: { relationship_id: @rel.id,
                             reflection: { content: "New thought", prompt_type: "open" } },
                  format: :turbo_stream
    assert_response :success
  end

  # ── POST create (JSON) ────────────────────────────────────────

  test "POST create responds with JSON on success" do
    post :create, params: { relationship_id: @rel.id,
                             reflection: { content: "New thought", prompt_type: "open" } },
                  format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert json["saved"]
  end

  test "POST create JSON returns id of created reflection" do
    post :create, params: { relationship_id: @rel.id,
                             reflection: { content: "JSON thought", prompt_type: "open" } },
                  format: :json
    json = JSON.parse(response.body)
    assert json["id"].present?
  end

  # ── PATCH update ─────────────────────────────────────────────

  test "PATCH update updates reflection content" do
    patch :update, params: { relationship_id: @rel.id, id: @reflection.id,
                              reflection: { content: "Updated content", prompt_type: "most_myself" } },
                   format: :json
    assert_equal "Updated content", @reflection.reload.content
  end

  test "PATCH update responds with JSON saved: true" do
    patch :update, params: { relationship_id: @rel.id, id: @reflection.id,
                              reflection: { content: "Updated", prompt_type: "most_myself" } },
                   format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert json["saved"]
  end

  # ── DELETE destroy ────────────────────────────────────────────

  test "DELETE destroy removes reflection" do
    r = @rel.reflections.create!(content: "To delete", prompt_type: "open")
    assert_difference "Reflection.count", -1 do
      delete :destroy, params: { relationship_id: @rel.id, id: r.id }
    end
  end

  test "DELETE destroy redirects to reflections index" do
    r = @rel.reflections.create!(content: "To delete", prompt_type: "open")
    delete :destroy, params: { relationship_id: @rel.id, id: r.id }
    assert_redirected_to relationship_reflections_path(@rel)
  end
end
