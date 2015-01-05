class Part < ActiveRecord::Base
	#attr_accessible :label, :sorting, :texts
	has_many :texts
end
