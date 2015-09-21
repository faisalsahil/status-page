class ChangeColumnsofMaintenances < ActiveRecord::Migration
  def up
    remove_column :maintenances, :start_at
    add_column :maintenances, :start_at, :datetime
    remove_column :maintenances, :end_at
    add_column :maintenances, :end_at, :datetime
  end

  def down
    remove_column :maintenances, :start_at
    add_column :maintenances, :start_at, :string
    remove_column :maintenances, :end_at
    add_column :maintenances, :end_at, :string
  end
end
