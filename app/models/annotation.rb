class Annotation < ActiveRecord::Base
	belongs_to :text
  belongs_to :sentence_model, class_name: 'Sentence', foreign_key: :sentence, primary_key: :checksum

	def self.all_grouped
		self.all(
			:group => "sentence",
			:select => "sentence, COUNT(*) as count"
		)
  end

  def as_json(options = {})
    h = super(options)
    h[:sentence_body] = sentence_model.body
    h
  end


end
