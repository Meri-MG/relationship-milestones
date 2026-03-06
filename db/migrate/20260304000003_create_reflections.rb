class CreateReflections < ActiveRecord::Migration[7.2]
  def change
    create_table :reflections do |t|
      t.references :relationship, null: false, foreign_key: true

      t.string  :prompt_type  # most_myself | patterns | carry_forward | open
      t.text    :content
      t.boolean :private_note, default: true

      t.timestamps
    end

    add_index :reflections, :created_at
  end
end
