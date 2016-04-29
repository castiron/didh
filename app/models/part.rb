class Part < ActiveRecord::Base
	has_many :texts
	belongs_to :edition
end
