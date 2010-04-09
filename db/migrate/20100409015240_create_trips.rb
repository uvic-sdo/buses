class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
			t.column :route_id, :integer
			t.column :day, :integer
			t.column :direction, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :trips
  end
end
