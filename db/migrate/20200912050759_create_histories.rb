class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|

      t.timestamps
    end
  end
end
