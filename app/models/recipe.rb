class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients, :dependent => :destroy
  has_many :instructions, :dependent => :destroy

  accepts_nested_attributes_for :ingredients, :instructions


  def copy_recipe(current_user)
    clone = self.dup
    clone.user_id = current_user.id
    clone.ingredients = self.ingredients
    clone.instructions = self.instructions
    return clone
  end

end
