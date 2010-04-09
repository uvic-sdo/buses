class Trip < ActiveRecord::Base
	belongs_to :route
	has_many :schedule_times
end
