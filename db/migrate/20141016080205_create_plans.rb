class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :plan_type
      t.integer :available_notifications

      t.timestamps
    end
  end
end
