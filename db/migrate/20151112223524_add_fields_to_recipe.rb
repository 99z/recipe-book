class AddFieldsToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :description, :string, default: 'Add a description...'
    add_column :recipes, :url, :string
  end
end
