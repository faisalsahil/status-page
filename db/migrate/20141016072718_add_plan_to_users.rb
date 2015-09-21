class AddPlanToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :plan, :integer, :default => 0
    add_column :users, :sent_notifications, :integer, :default => 0
  end
end
