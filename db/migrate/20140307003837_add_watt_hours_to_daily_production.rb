class AddWattHoursToDailyProduction < ActiveRecord::Migration
  def change
    add_column :daily_productions, :watts, :text
  end
end
