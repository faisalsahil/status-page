class AddColumnToCustomizepages < ActiveRecord::Migration
  def change
    add_column :customizepages, :user_id, :integer
  end
end
