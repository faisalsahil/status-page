class AddUserTypeFieldToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :user_type, :string, :default=> :null
  end
end
