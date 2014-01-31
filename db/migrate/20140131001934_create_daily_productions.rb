class CreateDailyProductions < ActiveRecord::Migration
  def change
    create_table :daily_productions do |t|
      t.text :power_array
      t.datetime :start_time
      t.integer :unix_time

      t.timestamps
    end
  end
end
