class Profile < ActiveRecord::Base
  belongs_to :user

  has_attached_file :avatar, :styles => { :medium => "300x300", :thumb => "100x100" }
  # You'll want to make sure you've whitelisted only acceptable
  # content types to avoid attacks
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def full_name
    self.first_name + " " + self.last_name
  end
end
