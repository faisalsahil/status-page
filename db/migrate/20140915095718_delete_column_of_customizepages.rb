class DeleteColumnOfCustomizepages < ActiveRecord::Migration
  def up
    remove_column :customizepages, :logo
  end

  def down
    add_column :customizepages, :logo, :string
  end
end
