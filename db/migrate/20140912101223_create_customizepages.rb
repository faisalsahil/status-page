class CreateCustomizepages < ActiveRecord::Migration
  def change
    create_table :customizepages do |t|
      t.string :theme
      t.string :logo
      t.string :favicon
      t.string :coverimage
      t.string :background_color
      t.string :font_color
      t.string :link_color
      t.string :yellows
      t.string :reds
      t.string :greens

      t.timestamps
    end
  end
end
