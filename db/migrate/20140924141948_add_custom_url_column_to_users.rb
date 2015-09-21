class AddCustomUrlColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customurl, :string
  end
end
