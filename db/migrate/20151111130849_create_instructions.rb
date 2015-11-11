class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.text :body, default: "Add your directions here...", null: false
      t.integer :recipe_id, null: false

      t.timestamps null: false
    end
  end
end
