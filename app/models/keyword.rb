class Keyword < ActiveRecord::Base
	belongs_to :text
	attr_accessible :word, :sentence, :text_id
end
