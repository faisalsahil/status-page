class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :userdef_name
      t.string :name
      t.string :hostname
      t.string :status
      t.integer :datasources_id

      t.timestamps
    end
  end
end
