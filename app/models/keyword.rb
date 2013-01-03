class Keyword < ActiveRecord::Base
	belongs_to :text
	attr_accessible :word, :sentence, :text_id

	def self.all_grouped
		self.all(
			:group => "sentence",
			:select => "sentence, COUNT(*) as count"
		)
	end
end
