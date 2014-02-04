class CreateMonthlyRecords < ActiveRecord::Migration
  def change
    create_table :monthly_records do |t|
      t.text :power_produced
      t.datetime :month
      t.timestamps
    end
  end
end
