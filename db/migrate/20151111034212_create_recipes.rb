class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title, default: "Add a title...", null: false
      t.string :author, default: "Add an author...", null: false
      t.text :body, default: "Add your directions here...", null: false
      t.text :ingredients, default: "['Add an ingredient...']", null: false
      t.string :photo_url, default: "https://placeholdit.imgix.net/~text?txtsize=30&txt=320%C3%97320&w=320&h=320"
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
