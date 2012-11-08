class Chapter < ActiveRecord::Base
  attr_accessible :label
  belongs_to :part
end
