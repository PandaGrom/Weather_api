class CreateTemperatureRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :temperature_records do |t|
      t.references :location, null: false, foreign_key: true
      t.decimal :value, null: false
      t.datetime :observation_time, null: false

      t.timestamps
    end
  end
end
