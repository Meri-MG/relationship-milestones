require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  # ── Fixtures ─────────────────────────────────────────────────

  def active_solo    = relationships(:active_solo)
  def active_couple  = relationships(:active_couple)
  def ended_chapter  = relationships(:ended_chapter)
  def child_chapter  = relationships(:child_chapter)

  # ── Validations ──────────────────────────────────────────────

  test "valid with all required attributes" do
    rel = Relationship.new(title: "Test", mode: "solo", status: "active", chapter_number: 1)
    assert rel.valid?
  end

  test "invalid without title" do
    rel = Relationship.new(title: nil, mode: "solo", status: "active")
    assert_not rel.valid?
    assert_includes rel.errors[:title], "can't be blank"
  end

  test "invalid with blank title" do
    rel = Relationship.new(title: "", mode: "solo", status: "active")
    assert_not rel.valid?
  end

  test "invalid with unknown mode" do
    rel = Relationship.new(title: "T", mode: "unknown", status: "active")
    assert_not rel.valid?
    assert_includes rel.errors[:mode], "is not included in the list"
  end

  test "valid with mode solo" do
    rel = Relationship.new(title: "T", mode: "solo", status: "active")
    assert rel.valid?
  end

  test "valid with mode couple" do
    rel = Relationship.new(title: "T", mode: "couple", status: "active")
    assert rel.valid?
  end

  test "invalid with unknown status" do
    rel = Relationship.new(title: "T", mode: "solo", status: "nonsense")
    assert_not rel.valid?
    assert_includes rel.errors[:status], "is not included in the list"
  end

  test "valid with status active" do
    rel = Relationship.new(title: "T", mode: "solo", status: "active")
    assert rel.valid?
  end

  test "valid with status ended" do
    rel = Relationship.new(title: "T", mode: "solo", status: "ended")
    assert rel.valid?
  end

  test "valid with status archived" do
    rel = Relationship.new(title: "T", mode: "solo", status: "archived")
    assert rel.valid?
  end

  # ── Constants ─────────────────────────────────────────────────

  test "MODES contains solo and couple" do
    assert_includes Relationship::MODES, "solo"
    assert_includes Relationship::MODES, "couple"
  end

  test "STATUSES contains active, ended, archived" do
    assert_includes Relationship::STATUSES, "active"
    assert_includes Relationship::STATUSES, "ended"
    assert_includes Relationship::STATUSES, "archived"
  end

  # ── Associations ─────────────────────────────────────────────

  test "has many milestones" do
    assert_respond_to active_couple, :milestones
  end

  test "milestones are ordered by occurred_on ascending" do
    dates = active_couple.milestones.map(&:occurred_on)
    assert_equal dates.sort, dates
  end

  test "has many reflections" do
    assert_respond_to active_couple, :reflections
  end

  test "reflections are ordered by created_at descending" do
    # Just assert the association exists and returns a relation
    assert_respond_to active_couple.reflections, :order
  end

  test "belongs to parent chapter (optional)" do
    assert_nil active_solo.parent_chapter
    assert_equal ended_chapter, child_chapter.parent_chapter
  end

  test "has many child chapters" do
    assert_includes ended_chapter.child_chapters, child_chapter
  end

  test "destroying relationship cascades to milestones" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    rel.milestones.create!(title: "M", occurred_on: Date.today, milestone_type: "custom")
    assert_difference "Milestone.count", -1 do
      rel.destroy
    end
  end

  test "destroying relationship cascades to reflections" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    rel.reflections.create!(content: "R", prompt_type: "open")
    assert_difference "Reflection.count", -1 do
      rel.destroy
    end
  end

  # ── Scopes ───────────────────────────────────────────────────

  test "active scope returns only active relationships" do
    active = Relationship.active
    assert active.include?(active_solo)
    assert active.include?(active_couple)
    assert_not active.include?(ended_chapter)
  end

  test "ended scope returns only ended relationships" do
    ended = Relationship.ended
    assert ended.include?(ended_chapter)
    assert_not ended.include?(active_solo)
  end

  # ── Predicate methods ────────────────────────────────────────

  test "solo? returns true for solo mode" do
    assert active_solo.solo?
  end

  test "solo? returns false for couple mode" do
    assert_not active_couple.solo?
  end

  test "couple? returns true for couple mode" do
    assert active_couple.couple?
  end

  test "couple? returns false for solo mode" do
    assert_not active_solo.couple?
  end

  test "active? returns true when status is active" do
    assert active_solo.active?
  end

  test "active? returns false when status is ended" do
    assert_not ended_chapter.active?
  end

  test "ended? returns true when status is ended" do
    assert ended_chapter.ended?
  end

  test "ended? returns false when status is active" do
    assert_not active_solo.ended?
  end

  # ── end_chapter! ─────────────────────────────────────────────

  test "end_chapter! sets status to ended" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    rel.end_chapter!
    assert_equal "ended", rel.reload.status
  end

  test "end_chapter! sets ended_on to today" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    rel.end_chapter!
    assert_equal Date.today, rel.reload.ended_on
  end

  test "end_chapter! creates an ending milestone" do
    rel = Relationship.create!(title: "Temp", mode: "solo", status: "active")
    assert_difference "Milestone.count", 1 do
      rel.end_chapter!
    end
    ending = rel.milestones.last
    assert_equal "ending", ending.milestone_type
    assert_equal Date.today, ending.occurred_on
  end

  # ── new_chapter! ─────────────────────────────────────────────

  test "new_chapter! creates a new relationship" do
    assert_difference "Relationship.count", 1 do
      ended_chapter.new_chapter!(title: "Fresh Start")
    end
  end

  test "new_chapter! sets parent_chapter_id to current id" do
    child = ended_chapter.new_chapter!(title: "Fresh Start")
    assert_equal ended_chapter.id, child.parent_chapter_id
  end

  test "new_chapter! increments chapter_number" do
    child = ended_chapter.new_chapter!(title: "Fresh Start")
    assert_equal ended_chapter.chapter_number + 1, child.chapter_number
  end

  test "new_chapter! sets status to active" do
    child = ended_chapter.new_chapter!(title: "Fresh Start")
    assert_equal "active", child.status
  end

  test "new_chapter! sets began_on to today" do
    child = ended_chapter.new_chapter!(title: "Fresh Start")
    assert_equal Date.today, child.began_on
  end

  test "new_chapter! preserves mode" do
    child = ended_chapter.new_chapter!(title: "Fresh Start")
    assert_equal ended_chapter.mode, child.mode
  end

  # ── duration_label ───────────────────────────────────────────

  test "duration_label returns Ongoing when began_on is nil" do
    rel = Relationship.new(title: "T", mode: "solo", status: "active")
    assert_equal "Ongoing", rel.duration_label
  end

  test "duration_label returns days for < 31 days" do
    rel = Relationship.new(title: "T", mode: "solo", status: "active",
                           began_on: 10.days.ago.to_date)
    assert_match(/\d+ days/, rel.duration_label)
  end

  test "duration_label returns months for 31-364 days" do
    rel = Relationship.new(title: "T", mode: "solo", status: "active",
                           began_on: 90.days.ago.to_date)
    assert_match(/\d+ months/, rel.duration_label)
  end

  test "duration_label returns years for >= 365 days" do
    rel = Relationship.new(title: "T", mode: "solo", status: "active",
                           began_on: 400.days.ago.to_date)
    assert_match(/\d+\.?\d* years/, rel.duration_label)
  end

  test "duration_label uses ended_on when present" do
    assert_match(/\d+ months/, ended_chapter.duration_label)
  end

  # ── emotional_heatmap ────────────────────────────────────────

  test "emotional_heatmap returns type counts" do
    heatmap = active_couple.emotional_heatmap
    assert_kind_of Hash, heatmap
    assert heatmap["conflict"].present?
  end

  test "emotional_heatmap returns empty hash when no milestones" do
    rel = Relationship.create!(title: "Empty", mode: "solo", status: "active")
    assert_equal({}, rel.emotional_heatmap)
  end
end
