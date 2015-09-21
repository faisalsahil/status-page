class AddNotificationIncidentsColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :emailsubjectincidentformat, :string
    add_column :users, :emailbodyincidentformat, :text
    add_column :users, :tweetincidentformat, :string
  end
end
