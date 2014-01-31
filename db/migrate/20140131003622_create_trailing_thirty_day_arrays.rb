class CreateTrailingThirtyDayArrays < ActiveRecord::Migration
  def change
    create_table :trailing_thirty_day_arrays do |t|
      t.text :power_array
      t.integer :start_date
      t.timestamps
    end
  end
end
