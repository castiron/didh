class Edition < ActiveRecord::Base
	has_many :texts
	has_many :parts
end
