class CreateMaintenances < ActiveRecord::Migration
  def change
    create_table :maintenances do |t|
      t.string :tile
      t.string :description
      t.string :start_at
      t.string :end_at
      t.integer :component_id

      t.timestamps
    end
  end
end
