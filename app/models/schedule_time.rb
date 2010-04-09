class ScheduleTime < ActiveRecord::Base
	belongs_to :trip
	belongs_to :stop
end
