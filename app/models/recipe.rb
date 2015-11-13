class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients, :dependent => :destroy
  has_many :instructions, :dependent => :destroy

  accepts_nested_attributes_for :ingredients, :instructions
end
