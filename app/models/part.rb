class Part < ActiveRecord::Base
  attr_accessible :label, :sorting
  has_many :texts
end
