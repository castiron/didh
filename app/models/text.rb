class Text < ActiveRecord::Base
	attr_accessible :body, :edition_id, :title, :abstract, :notes, :bibliography, :source_file, :authors, :author_ids, :part, :part_id, :sorting, :is_static
	has_and_belongs_to_many :authors
	belongs_to :part
	belongs_to :edition
	has_many :keywords
	has_many :annotations

	def author_names
		self.authors.collect { |author| author.name }.join(', ')
	end

	def as_json(options={})
		if options[:bootstrap] == true
			{
				:id => id,
				:title => title,
				:part => part_id,
        :is_static => is_static,
				:authors => authors

			}
		else
			{
				:id => id,
				:title => title,
				:part => part_id,
        :is_static => is_static,
				:body => body,
				:notes => notes,
				:bibliography => bibliography,
				:authors => authors,
				:edition => edition.label,
        :keywords_grouped => keywords.all_grouped,
        #:keywords => keywords,
				:sentences => annotations.all_grouped
			}
		end
	end

end
