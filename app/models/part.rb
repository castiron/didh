class Part < ActiveRecord::Base
  attr_accessible :label
  has_many :chapters
end
