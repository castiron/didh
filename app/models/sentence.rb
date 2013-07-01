class Sentence < ActiveRecord::Base

  attr_accessible :checksum, :body, :text_id

  def as_json(option = {})
    {
        :id => id,
        :checksum => checksum,
        :body => body,
        :text_id => text_id,
        :created_at => created_at,
        :annotations => Annotation.find_all_by_sentence(self.checksum),
        :comments => Comment.find_all_by_sentence_checksum(self.checksum),
        :keywords => Keyword.find_all_by_sentence(self.checksum)

    }
  end

end
