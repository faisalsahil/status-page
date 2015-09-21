class CreateDatasources < ActiveRecord::Migration
  def change
    create_table :datasources do |t|
      t.string :source_name
      t.string :ds_email
      t.string :ds_pass
      t.string :ds_appkey
      t.integer :user_id

      t.timestamps
    end
  end
end
