class AddRandomKeyToComponents < ActiveRecord::Migration
  def change
    add_column :components, :random_key, :string
  end
end
