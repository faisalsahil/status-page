class AddColumnsToPayment < ActiveRecord::Migration
  def change
  	add_column :payments , :card_number, :string
  	add_column :payments, :card_code, :string
  	add_column :payments , :card_exp_date, :string
  	add_column :payments, :user_id, :integer
  	add_column :payments, :token, :string
  	add_column :payments, :subscription_id, :string
  end
end