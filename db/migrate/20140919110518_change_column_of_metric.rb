class ChangeColumnOfMetric < ActiveRecord::Migration
  def change
  	remove_column :metrics, :datasources_id

  	add_column :metrics, :datasource_id, :integer
  end
end
