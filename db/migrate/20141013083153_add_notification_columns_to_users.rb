class AddNotificationColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :emailsubjectformat, :string
    add_column :users, :emailbodyformat, :text
    add_column :users, :tweetformat, :string
  end
end
