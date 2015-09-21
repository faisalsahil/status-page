class RenameOldTableToNewTable < ActiveRecord::Migration
  def up
    rename_table :sms, :smssubscribers
  end 
  def down
    rename_table :smssubscribers, :sms
  end
end
