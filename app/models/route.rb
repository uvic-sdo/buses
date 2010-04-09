class Route < ActiveRecord::Base
	has_many :trips
	has_many :schedule_times, :through => :trips
end
