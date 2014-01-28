class AddUnixTimeToEnergyLifetimeArrays < ActiveRecord::Migration
  def change
    add_column :energy_lifetime_arrays, :unix_time, :integer
  end
end
