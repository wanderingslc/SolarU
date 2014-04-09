class AddPeakTimeToDailyProduction < ActiveRecord::Migration
  def change
    add_column :daily_productions, :peak_time, :datetime
  end
end
