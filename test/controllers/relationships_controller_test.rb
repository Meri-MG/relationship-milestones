require "test_helper"

class RelationshipsControllerTest < ActionController::TestCase
  def setup
    @couple = relationships(:active_couple)
    @ended  = relationships(:ended_chapter)
  end

  # ── GET new ──────────────────────────────────────────────────

  test "GET new renders form" do
    get :new
    assert_response :success
    assert_select "form"
  end

  # ── POST create ──────────────────────────────────────────────

  test "POST create with valid params creates relationship" do
    assert_difference "Relationship.count", 1 do
      post :create, params: { relationship: { title: "New Chapter", mode: "solo",
                                              began_on: Date.today } }
    end
  end

  test "POST create sets session relationship_id" do
    post :create, params: { relationship: { title: "New Chapter", mode: "solo",
                                            began_on: Date.today } }
    assert_not_nil session[:relationship_id]
  end

  test "POST create redirects to relationship show" do
    post :create, params: { relationship: { title: "New Chapter", mode: "solo",
                                            began_on: Date.today } }
    assert_redirected_to relationship_path(Relationship.last)
  end

  test "POST create sets flash notice" do
    post :create, params: { relationship: { title: "New Chapter", mode: "solo",
                                            began_on: Date.today } }
    assert_equal "Your chapter has begun.", flash[:notice]
  end

  test "POST create with invalid params does not create relationship" do
    assert_no_difference "Relationship.count" do
      post :create, params: { relationship: { title: "", mode: "solo" } }
    end
  end

  test "POST create with invalid params renders new with unprocessable_entity" do
    post :create, params: { relationship: { title: "", mode: "solo" } }
    assert_response :unprocessable_entity
    assert_template :new
  end

  test "POST create with invalid mode does not create relationship" do
    assert_no_difference "Relationship.count" do
      post :create, params: { relationship: { title: "T", mode: "invalid", began_on: Date.today } }
    end
  end

  # ── GET show ─────────────────────────────────────────────────

  test "GET show renders timeline" do
    session[:relationship_id] = @couple.id
    get :show, params: { id: @couple.id }
    assert_response :success
  end

  test "GET show updates session relationship_id" do
    get :show, params: { id: @couple.id }
    assert_equal @couple.id, session[:relationship_id]
  end

  test "GET show without filter shows all milestones" do
    get :show, params: { id: @couple.id }
    assert_response :success
    assert_nil assigns(:filter)
  end

  test "GET show with filter shows filtered milestones" do
    get :show, params: { id: @couple.id, filter: "conflict" }
    assert_response :success
    assert_equal "conflict", assigns(:filter)
    assigns(:milestones).each do |m|
      assert_equal "conflict", m.milestone_type
    end
  end

  test "GET show with filter returns empty set when no matches" do
    get :show, params: { id: relationships(:active_solo).id, filter: "first" }
    assert_response :success
    assert_empty assigns(:milestones)
  end

  test "GET show for ended relationship shows ended content" do
    get :show, params: { id: @ended.id }
    assert_response :success
    assert_match(/Reflections are now open/, response.body)
  end

  test "GET show sets chapter chain" do
    child = relationships(:child_chapter)
    get :show, params: { id: child.id }
    assert_response :success
    assert_equal 2, assigns(:chapters).length
  end

  test "GET show for relationship without parent has single-element chain" do
    get :show, params: { id: @couple.id }
    assert_response :success
    assert_equal 1, assigns(:chapters).length
  end

  # ── PATCH end_chapter ─────────────────────────────────────────

  test "PATCH end_chapter sets status to ended" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    session[:relationship_id] = rel.id
    patch :end_chapter, params: { id: rel.id }
    assert_equal "ended", rel.reload.status
    rel.destroy
  end

  test "PATCH end_chapter redirects to relationship" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    session[:relationship_id] = rel.id
    patch :end_chapter, params: { id: rel.id }
    assert_redirected_to relationship_path(rel)
    rel.destroy
  end

  test "PATCH end_chapter sets notice" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    session[:relationship_id] = rel.id
    patch :end_chapter, params: { id: rel.id }
    assert_equal "This chapter has come to an end.", flash[:notice]
    rel.destroy
  end

  # ── POST new_chapter ─────────────────────────────────────────

  test "POST new_chapter creates a child relationship" do
    session[:relationship_id] = @ended.id
    assert_difference "Relationship.count", 1 do
      post :new_chapter, params: { id: @ended.id }
    end
  end

  test "POST new_chapter sets session to new relationship" do
    session[:relationship_id] = @ended.id
    post :new_chapter, params: { id: @ended.id }
    child = Relationship.last
    assert_equal child.id, session[:relationship_id]
  end

  test "POST new_chapter redirects to the new child relationship" do
    session[:relationship_id] = @ended.id
    post :new_chapter, params: { id: @ended.id }
    assert_redirected_to relationship_path(Relationship.last)
  end

  test "POST new_chapter sets notice" do
    session[:relationship_id] = @ended.id
    post :new_chapter, params: { id: @ended.id }
    assert_equal "A new beginning.", flash[:notice]
  end

  test "POST new_chapter links parent chapter" do
    session[:relationship_id] = @ended.id
    post :new_chapter, params: { id: @ended.id }
    assert_equal @ended.id, Relationship.last.parent_chapter_id
  end
end
