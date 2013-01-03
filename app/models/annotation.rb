class Annotation < ActiveRecord::Base
	belongs_to :text
	attr_accessible :ip, :sentence, :type, :text_id

	def self.all_grouped
		self.all(
			:group => "sentence",
			:select => "sentence, COUNT(*) as count"
		)
	end

end
