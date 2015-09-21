class AddStatusIdToComponents < ActiveRecord::Migration
  def change
  	add_column :components, :status_id, :integer
  end
end
