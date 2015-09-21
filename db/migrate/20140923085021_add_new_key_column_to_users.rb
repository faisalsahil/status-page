class AddNewKeyColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :random_key, :string
  end
end
