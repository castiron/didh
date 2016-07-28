class Sentence < ActiveRecord::Base

  has_many :comments, :foreign_key => :sentence_checksum, :primary_key => :checksum
  has_many :annotations, :dependent => :destroy, :foreign_key => :sentence, :primary_key => :checksum

  def as_json(option = {})
    {
        :id => id,
        :checksum => checksum,
        :body => body,
        :text_id => text_id,
        :created_at => created_at,
    }
  end

end
