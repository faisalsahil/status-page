class AddTwitterdataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid_twitter, :string
    add_column :users, :name_twitter, :string
  end
end
