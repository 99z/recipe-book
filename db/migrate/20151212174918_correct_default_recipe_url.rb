class CorrectDefaultRecipeUrl < ActiveRecord::Migration
  def change
    change_column :recipes, :photo_url, :string, default: "/images/pacman-pizza.jpg"
  end
end
