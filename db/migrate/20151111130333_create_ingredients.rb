class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name, default: "Add an ingredient...", null: false
      t.integer :recipe_id, null: false

      t.timestamps null: false
    end
  end
end
