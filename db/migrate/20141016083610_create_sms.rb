class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.string :phone
      t.integer :user_id

      t.timestamps
    end
  end
end
