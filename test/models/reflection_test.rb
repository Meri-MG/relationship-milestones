require "test_helper"

class ReflectionTest < ActiveSupport::TestCase
  def couple_rel       = relationships(:active_couple)
  def most_myself      = reflections(:most_myself)
  def patterns_ref     = reflections(:patterns)
  def carry_forward    = reflections(:carry_forward)
  def open_ref         = reflections(:open_reflection)

  # ── Constants ────────────────────────────────────────────────

  test "PROMPTS contains all expected keys" do
    %w[most_myself patterns carry_forward open].each do |key|
      assert Reflection::PROMPTS.key?(key), "PROMPTS missing: #{key}"
    end
  end

  test "PROMPTS open has nil value" do
    assert_nil Reflection::PROMPTS["open"]
  end

  test "PROMPTS non-open keys have string values" do
    %w[most_myself patterns carry_forward].each do |key|
      assert_kind_of String, Reflection::PROMPTS[key]
    end
  end

  # ── Validations ──────────────────────────────────────────────

  test "valid with relationship and content" do
    r = Reflection.new(relationship: couple_rel, content: "Some text",
                       prompt_type: "open")
    assert r.valid?
  end

  test "invalid without relationship" do
    r = Reflection.new(relationship: nil, content: "Text", prompt_type: "open")
    assert_not r.valid?
    assert_includes r.errors[:relationship], "must exist"
  end

  # ── Scopes ───────────────────────────────────────────────────

  test "recent scope orders by created_at descending" do
    refs = couple_rel.reflections.recent
    times = refs.map(&:created_at)
    assert_equal times.sort.reverse, times
  end

  # ── Instance methods ─────────────────────────────────────────

  test "prompt_text returns question for most_myself" do
    assert_equal Reflection::PROMPTS["most_myself"], most_myself.prompt_text
  end

  test "prompt_text returns question for patterns" do
    assert_equal Reflection::PROMPTS["patterns"], patterns_ref.prompt_text
  end

  test "prompt_text returns question for carry_forward" do
    assert_equal Reflection::PROMPTS["carry_forward"], carry_forward.prompt_text
  end

  test "prompt_text returns nil for open" do
    assert_nil open_ref.prompt_text
  end

  test "open? returns true when prompt_type is open" do
    assert open_ref.open?
  end

  test "open? returns true when prompt_type is nil" do
    r = Reflection.new(relationship: couple_rel, content: "Text",
                       prompt_type: nil)
    assert r.open?
  end

  test "open? returns false for guided prompt types" do
    assert_not most_myself.open?
    assert_not patterns_ref.open?
    assert_not carry_forward.open?
  end

  # ── Associations ─────────────────────────────────────────────

  test "belongs to relationship" do
    assert_equal couple_rel, most_myself.relationship
  end

  # ── Persistence ──────────────────────────────────────────────

  test "can be created and retrieved" do
    assert_difference "Reflection.count", 1 do
      couple_rel.reflections.create!(content: "New thought", prompt_type: "open")
    end
  end

  test "private_note defaults to true" do
    r = couple_rel.reflections.create!(content: "Text", prompt_type: "open")
    assert r.private_note
    r.destroy
  end
end
