class AddDefaultRecipeImg < ActiveRecord::Migration
  def change
    change_column :recipes, :photo_url, :string, default: "/public/images/pacman-pizza.jpg"
  end
end
