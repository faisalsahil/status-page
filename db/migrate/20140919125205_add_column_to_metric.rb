class AddColumnToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :displayit, :boolean
  end
end
