class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  has_many :notes, :as => :notable
end
