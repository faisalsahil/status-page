class AddStateIdToIncidents < ActiveRecord::Migration
  def change
    add_column :incidents, :state_id, :integer
  end
end
