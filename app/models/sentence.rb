class Sentence < ActiveRecord::Base
  belongs_to :text, inverse_of: :sentences
  has_one :edition, through: :text

  has_many :comments, :foreign_key => :sentence_checksum, :primary_key => :checksum
  has_many :annotations, :dependent => :destroy, :foreign_key => :sentence, :primary_key => :checksum

  scope :exportable, -> { included_in_export.positioned.has_comments_or_annotations }
  scope :included_in_export, -> { where(excluded_from_export: false) }
  scope :positioned, -> { where.not(position: nil) }

  def as_json(option = {})
    {
      :id => id,
      :checksum => checksum,
      :body => body,
      :text_id => text_id,
      :created_at => created_at,
    }
  end

  class << self
    def has_comments_or_annotations
      annotations = Annotation.exportable.distinct.select(:sentence)
      comments    = Comment.exportable.distinct.select(:sentence_checksum)

      checksum = arel_table[:checksum]

      where checksum.in(Arel.sql(annotations.to_sql)).or(checksum.in(Arel.sql(comments.to_sql)))
    end
  end
end
