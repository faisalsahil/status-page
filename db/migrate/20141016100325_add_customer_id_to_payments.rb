class AddCustomerIdToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :customer_id,:string
  	add_column :payments, :plan_id,:integer
  end
end
