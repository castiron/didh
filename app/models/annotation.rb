class Annotation < ActiveRecord::Base
	belongs_to :text
  belongs_to :sentence_model, class_name: 'Sentence', foreign_key: :sentence, primary_key: :checksum

  def self.all_grouped
    self.group(:sentence).select("sentence, COUNT(*) as count")
  end

  def self.all_grouped_max_n
    self.group(:sentence).select("sentence, COUNT(*) as count").order(count: :desc).limit(1)
  end

  def as_json(options = {})
    h = super(options)
    h[:sentence_body] = sentence_model.body
    h
  end

end
