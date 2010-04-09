class Stop < ActiveRecord::Base
	has_many :schedule_times
	def self.get_by_name name
		Stop.find_by_name(name) || Stop.create(:name=>name)
	end
end
