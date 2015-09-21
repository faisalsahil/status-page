class ChangeDefaultValueofUser < ActiveRecord::Migration
  def change
  	remove_column :users, :plan
  	add_column :users, :plan, :integer, :default => 1
  end
end
