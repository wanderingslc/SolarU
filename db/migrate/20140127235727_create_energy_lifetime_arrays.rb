class CreateEnergyLifetimeArrays < ActiveRecord::Migration
  def change
    create_table :energy_lifetime_arrays do |t|
      t.text :lifetime_data
      t.datetime :start_date
      
      t.timestamps
    end
  end
end
