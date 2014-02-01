class CreateLastSevenDaysArrays < ActiveRecord::Migration
  def change
    create_table :last_seven_days_arrays do |t|
      t.integer :start_date
      t.text :power_array
      t.timestamps
    end
  end
end
