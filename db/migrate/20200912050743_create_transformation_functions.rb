class CreateTransformationFunctions < ActiveRecord::Migration[6.0]
  def change
    create_table :transformation_functions do |t|

      t.timestamps
    end
  end
end
