class ScheduleTime < ActiveRecord::Base
	belongs_to :trip
	belongs_to :stop
	has_one :route, :through => :trip
end
