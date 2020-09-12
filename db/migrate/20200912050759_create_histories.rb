class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.references :channel, foreign_key: true
      t.boolean :success, :default => true
      t.json :metadata
      t.text :payload
      t.text :transformed_payload

      t.timestamps
    end
  end
end
