class AddComponentIdToIncidents < ActiveRecord::Migration
  def change
  	add_column :incidents, :component_id, :integer
  end
end
