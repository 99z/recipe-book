class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients, :dependent => :destroy
  has_many :instructions, :dependent => :destroy
  has_many :shares, :dependent => :destroy

  accepts_nested_attributes_for :ingredients, :instructions

  before_save :verify_photo


  def copy_recipe(current_user)
    clone = self.dup
    clone.user_id = current_user.id
    clone.ingredients = self.ingredients
    clone.instructions = self.instructions
    return clone
  end


  def verify_photo
    self.photo_url = "/images/pacman-pizza.jpg" if self.photo_url.nil?
  end

end
