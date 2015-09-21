class AddHistoryColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :history, :integer, :default => 30
  end
end
