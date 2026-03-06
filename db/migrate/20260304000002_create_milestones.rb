class CreateMilestones < ActiveRecord::Migration[7.2]
  def change
    create_table :milestones do |t|
      t.references :relationship, null: false, foreign_key: true

      t.string   :title,               null: false
      t.date     :occurred_on,          null: false
      t.string   :milestone_type,       null: false, default: "custom"
      # Types: first | funny | conflict | growth | transition | ending | custom

      t.text     :description
      t.text     :my_perspective
      t.text     :partner_perspective
      t.text     :repair_notes          # for conflict type

      t.string   :emotional_tags,       array: true, default: []
      # e.g. ["joy", "tension", "vulnerability", "stability", "growth"]

      t.integer  :emotional_intensity,  default: 5  # 1–10 slider
      t.string   :photo_filename
      t.boolean  :awaiting_confirmation, default: false  # for couple mode

      t.timestamps
    end

    add_index :milestones, :occurred_on
    add_index :milestones, :milestone_type
  end
end
