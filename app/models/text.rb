class Text < ActiveRecord::Base
  has_many :authors_texts
  has_many :authors, through: :authors_texts
  belongs_to :part
  belongs_to :edition
  has_many :keywords
  has_many :comments
  has_many :sentences, inverse_of: :text
  has_many :annotations

  composed_of :parsed_body, class_name: 'Nokogiri::HTML::DocumentFragment', mapping: %w[body to_html],
    allow_nil: false,
    constructor: ->(body) { Nokogiri::HTML.fragment(body) }

  def sorted_authors
    authors = self.authors_texts.order("sorting ASC").map { |author_text| author_text.author }
  end

  def author_names
    sorted_authors.collect { |author| author.name }.join(', ')
  end

  def comment_counts
    comments.group(:sentence_checksum).count
  end

  def nokogiri_body
    @nokogiri_body
  end

  def sentence_positions
    @sentence_positions ||= parsed_body.css('span.sentence').map.with_index do |node, idx|
      [node.attr('data-id'), idx + 1]
    end
  end

  def sentence_counts_are_correct
    return true if sentence_positions.length == sentences.size || errant_sentences.blank?
  end

  def errant_sentences
    @errant_sentences ||= sentences.reject do |sentence|
      chk = sentence.checksum.to_s

      sentence_positions.any? do |(checksum, idx)|
        chk == checksum
      end || sentence.comments.with_user.count == 0
    end
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
