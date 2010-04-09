class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
			t.column :number, :string
			t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :routes
  end
end
