class AddLogoToCustomizepages < ActiveRecord::Migration
  def change
    add_column :customizepages, :logo, :string
  end
end
