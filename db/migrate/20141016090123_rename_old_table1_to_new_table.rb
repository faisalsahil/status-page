class RenameOldTable1ToNewTable < ActiveRecord::Migration
  def up
    rename_table :smssubscribers, :clients
  end 
  def down
    rename_table :clients, :smssubscribers
  end
end
