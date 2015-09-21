class AddDefaultColumnToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :default_value, :string
  end
end
