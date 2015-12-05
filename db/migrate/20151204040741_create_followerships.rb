class CreateFollowerships < ActiveRecord::Migration
  def change
    create_table :followerships do |t|
      t.integer :followed_id
      t.integer :follower_id

      t.timestamps null: false
    end
    add_index :followerships, [:followed_id, :follower_id], unique: true
  end
end
