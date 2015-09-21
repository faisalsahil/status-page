class AddKeyColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :randmon_key, :string
  end
end
