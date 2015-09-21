class RemoveKeyColumnFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :randmon_key
  end

  def down
    add_column :users, :randmon_key, :string
  end
end
