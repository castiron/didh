class Text < ActiveRecord::Base
  attr_accessible :body, :edition, :title, :abstract, :notes, :bibliography, :source_file, :authors, :author_ids, :part, :part_id
  has_and_belongs_to_many :authors
  belongs_to :part
  belongs_to :edition
  has_many :sentences

  def author_names
  	self.authors.collect { |author| author.name }.join(', ')
  end

  def as_json(options={})
    {
      :id => id,
      :title => title,
      :part => part_id,
    }
  end

end
