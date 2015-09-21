class AddColumndToCustomizepages < ActiveRecord::Migration
  def change
    add_column :customizepages, :logoname, :string
    add_column :customizepages, :abouttext, :text
    add_column :customizepages, :coverimageshow, :boolean
  end
end
