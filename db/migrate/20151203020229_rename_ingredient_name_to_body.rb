class RenameIngredientNameToBody < ActiveRecord::Migration
  def change
    rename_column :ingredients, :name, :body
  end
end
