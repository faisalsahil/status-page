class AddColumnsToCustomizepages < ActiveRecord::Migration
  def change
    add_column :customizepages, :systemcomponentstitle, :string
    add_column :customizepages, :abouttexttitle, :string
    
  end
end
