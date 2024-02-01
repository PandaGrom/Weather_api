class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :uuid, null: false
      t.string :location_name, null: false

      t.index :uuid, unique: true
      t.timestamps
    end
  end
end
