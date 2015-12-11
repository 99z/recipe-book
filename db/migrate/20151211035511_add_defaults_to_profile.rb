class AddDefaultsToProfile < ActiveRecord::Migration
  def change
    change_column :profiles, :first_name, :string, null: false, default: "First Name"
    change_column :profiles, :last_name, :string, null: false, default: "Last Name"
    change_column :profiles, :location, :string, null: false, default: "???"
  end
end
