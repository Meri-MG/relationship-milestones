class Relationship < ApplicationRecord
  MODES    = %w[solo couple].freeze
  STATUSES = %w[active ended archived].freeze

  has_many :milestones,  -> { order(occurred_on: :asc) },  dependent: :destroy
  has_many :reflections, -> { order(created_at: :desc) }, dependent: :destroy

  belongs_to :parent_chapter, class_name: "Relationship", optional: true
  has_many   :child_chapters, class_name: "Relationship", foreign_key: :parent_chapter_id

  validates :title,   presence: true
  validates :mode,    inclusion: { in: MODES }
  validates :status,  inclusion: { in: STATUSES }

  scope :active,  -> { where(status: "active") }
  scope :ended,   -> { where(status: "ended") }

  def solo?;   mode == "solo";   end
  def couple?; mode == "couple"; end
  def active?; status == "active"; end
  def ended?;  status == "ended";  end

  def end_chapter!
    update!(status: "ended", ended_on: Date.today)
    milestones.create!(
      title:          "Chapter closed",
      occurred_on:    Date.today,
      milestone_type: "ending",
      description:    "This chapter has come to an end."
    )
  end

  def new_chapter!(attrs = {})
    self.class.create!(attrs.merge(
      parent_chapter_id: id,
      chapter_number:    chapter_number + 1,
      mode:              mode,
      status:            "active",
      began_on:          Date.today
    ))
  end

  def duration_label
    return "Ongoing" unless began_on
    finish = ended_on || Date.today
    days   = (finish - began_on).to_i
    case days
    when 0..30    then "#{days} days"
    when 31..364  then "#{(days / 30.0).round} months"
    else               "#{(days / 365.0).round(1)} years"
    end
  end

  def emotional_heatmap
    milestones.group_by(&:milestone_type).transform_values(&:count)
  end
end
