class ChangeColumnofMaintenances < ActiveRecord::Migration
  def up
    remove_column :maintenances, :tile
    add_column :maintenances, :title, :string
  end

  def down
    remove_column :maintenances, :title
    add_column :maintenances, :tile, :string
  end
end
