class AddCustomfooterToCustomizepages < ActiveRecord::Migration
  def change
    add_column :customizepages, :customfooter, :text
  end
end
