class Route < ActiveRecord::Base
	has_many :trips
	has_many :schedule_times, :through => :trips
	has_many :stops, :through => :schedule_times
end
