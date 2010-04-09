class CreateScheduleTimes < ActiveRecord::Migration
  def self.up
    create_table :schedule_times do |t|
			t.column :time, :integer
			t.column :stop_id, :integer
			t.column :trip_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :schedule_times
  end
end
