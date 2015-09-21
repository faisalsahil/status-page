class ChangeFieldTypeFromPlans < ActiveRecord::Migration
  def change
  	remove_column :plans, :plan_type
  	add_column :plans, :plan_type, :string
  end
end
