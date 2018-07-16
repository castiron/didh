class Annotation < ActiveRecord::Base
  belongs_to :user_ip_mapping, foreign_key: :ip, primary_key: :ip_address
  has_one :user, through: :user_ip_mapping
  belongs_to :text
  belongs_to :sentence_model, class_name: 'Sentence', foreign_key: :sentence, primary_key: :checksum

  scope :exportable, -> { where(ip: UserIpMapping.distinct.select(:ip_address)) }

  delegate :body, to: :sentence_model, prefix: :sentence, allow_nil: true
  delegate :id, to: :user, allow_nil: true, prefix: true

  def self.all_grouped
    self.group(:sentence).select("sentence, COUNT(*) as count")
  end

  def as_json(options = {})
    super.merge(sentence_body: sentence_body)
  end
end
