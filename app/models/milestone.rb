class Milestone < ApplicationRecord
  TYPES = %w[first funny conflict growth transition ending custom].freeze

  EMOTIONAL_TAGS = %w[
    joy tenderness tension vulnerability
    growth stability humor longing
    repair pride grief gratitude
  ].freeze

  TYPE_LABELS = {
    "first"      => "First",
    "funny"      => "Funny threshold",
    "conflict"   => "Conflict",
    "growth"     => "Growth",
    "transition" => "Transition",
    "ending"     => "Ending",
    "custom"     => "Custom",
  }.freeze

  TYPE_COLORS = {
    "first"      => "sage",
    "funny"      => "warm",
    "conflict"   => "rose",
    "growth"     => "sage",
    "transition" => "slate",
    "ending"     => "warm",
    "custom"     => "warm",
  }.freeze

  belongs_to :relationship
  has_one_attached :photo

  validates :title,          presence: true
  validates :occurred_on,    presence: true
  validates :milestone_type, inclusion: { in: TYPES }

  scope :by_type, ->(t) { where(milestone_type: t) }
  scope :recent,  -> { reorder(occurred_on: :desc) }

  def type_label
    TYPE_LABELS.fetch(milestone_type, "Custom")
  end

  def type_color
    TYPE_COLORS.fetch(milestone_type, "warm")
  end

  def conflict?;   milestone_type == "conflict"; end
  def growth?;     milestone_type == "growth";   end
  def ending?;     milestone_type == "ending";   end
end
