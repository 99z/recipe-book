class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, :dependent => :destroy
  has_many :recipes, :dependent => :destroy
  has_many :active_followerships, class_name: "Followership",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_followerships, class_name: "Followership",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_followerships, source: :followed
  has_many :followers, through: :passive_followerships, source: :follower

  def follow(other_user)
    active_followerships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_followerships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def following_activity_recent
    activity = []
    self.following.each do |user|
      user.recipes.each do |recipe|
        recipe_activity = Hash["author" => user.profile,
                               "activity" => "added a recipe for " + recipe.title,
                               "date" => recipe.created_at,
                               "type" => "recipe",
                               "target" => recipe]
        activity << recipe_activity
      end

      user.active_followerships.each do |follow|
        follow_activity = Hash["author" => user.profile,
                               "activity" => "started following " + User.find(follow.followed_id).profile.full_name,
                               "date" => follow.created_at,
                               "type" => "follow",
                               "target" => User.find(follow.followed_id).profile]
        activity << follow_activity
      end
    end

    activity.last(20).reverse
  end
end
