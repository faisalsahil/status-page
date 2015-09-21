class RemoveColumnFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :time_zone
  end

  def down
    add_column :users, :time_zone, :string
  end
end
