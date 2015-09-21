class AddColumnToStates < ActiveRecord::Migration
  def change
    add_column :states, :default_value, :string
  end
end
