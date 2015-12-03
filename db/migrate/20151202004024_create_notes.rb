class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :body, null: false, default: "Add a note..."
      t.string :notable_type, null: false
      t.integer :notable_id, null: false

      t.timestamps null: false
    end
  end
end
