class ChangeDefaultsValueofUser < ActiveRecord::Migration
def change
  	remove_column :users, :plan
  	add_column :users, :plan, :string, :default => 'Free'
  end
end
