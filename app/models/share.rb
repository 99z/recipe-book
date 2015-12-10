class Share < ActiveRecord::Base
  belongs_to :sharer, class_name: "User"
  belongs_to :recipient, class_name: "User"
  belongs_to :recipe
end
