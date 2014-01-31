class CreateWeatherRecords < ActiveRecord::Migration
  def change
    create_table :weather_records do |t|
      t.integer :date
      t.text :cloud_cover
      t.text :temperature
      t.timestamps
    end
  end
end



