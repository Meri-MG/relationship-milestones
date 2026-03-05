class Reflection < ApplicationRecord
  PROMPTS = {
    "most_myself"   => "When did I feel most myself?",
    "patterns"      => "What patterns repeat?",
    "carry_forward" => "What will I carry forward?",
    "open"          => nil,  # free-form
  }.freeze

  belongs_to :relationship

  validates :relationship, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def prompt_text
    PROMPTS[prompt_type]
  end

  def open?
    prompt_type == "open" || prompt_type.nil?
  end
end
