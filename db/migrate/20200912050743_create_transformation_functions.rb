class CreateTransformationFunctions < ActiveRecord::Migration[6.0]
  def change
    create_table :transformation_functions do |t|
      t.text :function
      t.string :language
      t.references :channel, foreign_key: true

      t.timestamps
    end
  end
end
