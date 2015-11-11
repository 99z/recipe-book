class RemoveBodyAndIngredientsFromRecipe < ActiveRecord::Migration
  def change
    remove_column :recipes, :body
    remove_column :recipes, :ingredients
  end
end
