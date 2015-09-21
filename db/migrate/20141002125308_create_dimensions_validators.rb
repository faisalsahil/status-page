class CreateDimensionsValidators < ActiveRecord::Migration
  def change
    create_table :dimensions_validators do |t|

      t.timestamps
    end
  end
end
