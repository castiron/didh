class SentenceMapping < ActiveRecord::Base
  has_many :annotations, foreign_key: :sentence, primary_key: :checksum
  has_many :comments, foreign_key: :sentence_checksum, primary_key: :checksum

  belongs_to :text
  belongs_to :edition
  
  scope :by_edition, ->(edition) { where(edition: edition) }
  scope :exportable, -> { where(exportable: true) }

  class << self
    def refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
    end
  end
end
