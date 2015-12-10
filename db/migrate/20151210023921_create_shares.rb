class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :sharer_id, null: false
      t.integer :recipient_id, null: false
      t.integer :recipe_id, null: false

      t.timestamps null: false
    end
  end
end
