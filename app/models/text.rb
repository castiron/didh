class Text < ActiveRecord::Base
	has_many :authors_texts
	has_many :authors, through: :authors_texts
	belongs_to :part
	belongs_to :edition
	has_many :keywords
  has_many :comments
  has_many :sentences
	has_many :annotations

	def sorted_authors
		authors = self.authors_texts.order("sorting ASC").map { |author_text| author_text.author }
	end

	def author_names
		sorted_authors.collect { |author| author.name }.join(', ')
	end

  def comment_counts
		comments.group(:sentence_checksum).count
  end

	def as_json(options={})
		if options[:bootstrap] == true
			{
				:id => id,
				:title => title,
				:part => part_id,
				:is_static => is_static,
				:authors => sorted_authors,
				:edition_id => edition_id
			}
		else
			{
        :comments => comment_counts,
				:id => id,
				:title => title,
				:part => part_id,
				:is_static => is_static,
				:body => body,
				:notes => notes,
				:bibliography => bibliography,
				:authors => sorted_authors,
				:edition => edition.label,
				:keywords_grouped => keywords.all_grouped,
				:sentences => annotations.all_grouped
			}
		end
	end

end
