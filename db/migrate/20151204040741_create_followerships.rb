class CreateFollowerships < ActiveRecord::Migration
  def change
    create_table :followerships do |t|
      t.integer :followed_id, null: false
      t.integer :follower_id, null: false

      t.timestamps null: false
    end
    add_index :followerships, [:followed_id, :follower_id], unique: true
  end
end
