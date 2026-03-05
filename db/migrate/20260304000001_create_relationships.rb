class CreateRelationships < ActiveRecord::Migration[7.2]
  def change
    create_table :relationships do |t|
      t.string  :title,            null: false, default: "Our Story"
      t.string  :mode,             null: false, default: "solo"   # solo | couple
      t.string  :status,           null: false, default: "active" # active | ended | archived
      t.integer :chapter_number,   null: false, default: 1
      t.bigint  :parent_chapter_id # references previous chapter for reconciliation
      t.date    :began_on
      t.date    :ended_on
      t.text    :description

      t.timestamps
    end

    add_index :relationships, :status
    add_index :relationships, :parent_chapter_id
  end
end
