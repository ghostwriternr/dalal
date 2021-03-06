class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :uuid
      t.string :target, :default => ''
      t.text :function
      t.string :language

      t.timestamps
    end
  end
end
