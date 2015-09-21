class AddColumnsToCustomizapages < ActiveRecord::Migration
  def change
    add_column :customizepages, :customcss, :text
    add_column :customizepages, :customheader, :text
  end
end
