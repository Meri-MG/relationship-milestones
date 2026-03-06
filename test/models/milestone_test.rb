require "test_helper"

class MilestoneTest < ActiveSupport::TestCase
  def couple_rel    = relationships(:active_couple)
  def first_one     = milestones(:first_meeting)
  def conflict_one  = milestones(:conflict_one)
  def growth_one    = milestones(:growth_one)
  def ending_one    = milestones(:ending_milestone)
  def funny_one     = milestones(:funny_threshold)
  def transition_one = milestones(:transition_one)
  def custom_one    = milestones(:custom_one)

  # ── Constants ────────────────────────────────────────────────

  test "TYPES includes all expected types" do
    %w[first funny conflict growth transition ending custom].each do |t|
      assert_includes Milestone::TYPES, t
    end
  end

  test "EMOTIONAL_TAGS includes expected tags" do
    %w[joy tenderness tension vulnerability growth stability humor].each do |tag|
      assert_includes Milestone::EMOTIONAL_TAGS, tag
    end
  end

  test "TYPE_LABELS maps all types" do
    Milestone::TYPES.each do |t|
      assert Milestone::TYPE_LABELS.key?(t), "TYPE_LABELS missing: #{t}"
    end
  end

  test "TYPE_COLORS maps all types" do
    Milestone::TYPES.each do |t|
      assert Milestone::TYPE_COLORS.key?(t), "TYPE_COLORS missing: #{t}"
    end
  end

  # ── Validations ──────────────────────────────────────────────

  test "valid with required attributes" do
    m = Milestone.new(relationship: couple_rel, title: "Test",
                      occurred_on: Date.today, milestone_type: "custom")
    assert m.valid?
  end

  test "invalid without title" do
    m = Milestone.new(relationship: couple_rel, title: nil,
                      occurred_on: Date.today, milestone_type: "custom")
    assert_not m.valid?
    assert_includes m.errors[:title], "can't be blank"
  end

  test "invalid without occurred_on" do
    m = Milestone.new(relationship: couple_rel, title: "Test",
                      occurred_on: nil, milestone_type: "custom")
    assert_not m.valid?
    assert_includes m.errors[:occurred_on], "can't be blank"
  end

  test "invalid with unknown milestone_type" do
    m = Milestone.new(relationship: couple_rel, title: "Test",
                      occurred_on: Date.today, milestone_type: "invalid_type")
    assert_not m.valid?
    assert_includes m.errors[:milestone_type], "is not included in the list"
  end

  test "invalid without relationship" do
    m = Milestone.new(relationship: nil, title: "Test",
                      occurred_on: Date.today, milestone_type: "custom")
    assert_not m.valid?
  end

  # ── Scopes ───────────────────────────────────────────────────

  test "by_type scope filters by milestone_type" do
    conflicts = couple_rel.milestones.by_type("conflict")
    conflicts.each { |m| assert_equal "conflict", m.milestone_type }
    assert conflicts.count >= 2
  end

  test "by_type scope returns empty when no matches" do
    # active_solo only has a custom milestone
    solo_firsts = relationships(:active_solo).milestones.by_type("first")
    assert solo_firsts.empty?
  end

  test "recent scope orders by occurred_on descending" do
    dates = couple_rel.milestones.recent.map(&:occurred_on)
    assert_equal dates.sort.reverse, dates
  end

  # ── Instance methods ─────────────────────────────────────────

  test "type_label returns human label for first" do
    assert_equal "First", first_one.type_label
  end

  test "type_label returns human label for funny" do
    assert_equal "Funny threshold", funny_one.type_label
  end

  test "type_label returns human label for conflict" do
    assert_equal "Conflict", conflict_one.type_label
  end

  test "type_label returns human label for growth" do
    assert_equal "Growth", growth_one.type_label
  end

  test "type_label returns human label for transition" do
    assert_equal "Transition", transition_one.type_label
  end

  test "type_label returns human label for ending" do
    assert_equal "Ending", ending_one.type_label
  end

  test "type_label returns Custom for custom type" do
    assert_equal "Custom", custom_one.type_label
  end

  test "type_color returns expected color string" do
    assert_equal "sage",  first_one.type_color
    assert_equal "warm",  funny_one.type_color
    assert_equal "rose",  conflict_one.type_color
    assert_equal "sage",  growth_one.type_color
    assert_equal "slate", transition_one.type_color
    assert_equal "warm",  ending_one.type_color
    assert_equal "warm",  custom_one.type_color
  end

  # ── Predicate methods ─────────────────────────────────────────

  test "conflict? returns true for conflict type" do
    assert conflict_one.conflict?
  end

  test "conflict? returns false for non-conflict" do
    assert_not first_one.conflict?
    assert_not growth_one.conflict?
    assert_not funny_one.conflict?
  end

  test "growth? returns true for growth type" do
    assert growth_one.growth?
  end

  test "growth? returns false for non-growth" do
    assert_not first_one.growth?
    assert_not conflict_one.growth?
  end

  test "ending? returns true for ending type" do
    assert ending_one.ending?
  end

  test "ending? returns false for non-ending" do
    assert_not first_one.ending?
    assert_not conflict_one.ending?
  end

  # ── Associations ─────────────────────────────────────────────

  test "belongs to relationship" do
    assert_equal couple_rel, first_one.relationship
  end

  # ── emotional_tags (array column) ────────────────────────────

  test "emotional_tags defaults to empty array" do
    m = couple_rel.milestones.create!(title: "T", occurred_on: Date.today,
                                      milestone_type: "custom")
    assert_equal [], m.emotional_tags
    m.destroy
  end

  test "emotional_tags can store multiple tags" do
    m = couple_rel.milestones.create!(title: "Tagged", occurred_on: Date.today,
                                      milestone_type: "growth",
                                      emotional_tags: [ "joy", "growth" ])
    assert_includes m.reload.emotional_tags, "joy"
    assert_includes m.reload.emotional_tags, "growth"
    m.destroy
  end
end
