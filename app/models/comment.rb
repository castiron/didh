class Comment < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::SanitizeHelper

  belongs_to :text
  belongs_to :user
  belongs_to :sentence, foreign_key: :sentence_checksum, primary_key: :checksum
  has_many :children, :class_name => 'Comment', :foreign_key => 'parent_id', :dependent => :destroy

  scope :anonymous, -> { where(user_id: nil) }
  scope :with_user, -> { where.not(user_id: nil) }
  scope :not_part_of_a_thread, -> { with_no_children.roots }
  scope :part_of_a_thread, -> { where.not(id: unscoped.not_part_of_a_thread) }
  scope :roots, -> { where parent_id: nil }
  scope :with_children, -> { where(id: parent_ids) }
  scope :with_no_children, -> { where.not(id: parent_ids) }
  scope :orphaned, -> { where.not(sentence_checksum: Sentence.distinct.select(:checksum)) }
  scope :exportable, -> { where.not(id: unscoped.orphaned.select(:id)).where.not(id: unscoped.probably_spam.select(:id)) }

  delegate :body, to: :sentence, prefix: true, allow_nil: true

  validates :body, :sentence_checksum, presence: true
  validates :parent_id, numericality: true, allow_nil: true
  validates :user_id, numericality: true, allow_nil: true

  with_options unless: :user_id? do |comment|
    comment.validates :author_name, :author_email, presence: true
  end

  def sanitized_body
    simple_format(sanitize(body, tags: %w(strong em)))
  end

  def screen_name
    if user
      if user.alias
        out = user.alias
      elsif user.name
        out = user.name
      else
        out = 'no name'
      end
    elsif author_name
      out = author_name
    else
      out = 'anonymous'
    end
    sanitize(out, :tags => [])
  end

  def calculate_age
    minutes = ((Time.now - created_at.to_time) / 60).ceil

    if minutes < 1
      return "less than 1 minute ago"
    elsif minutes < 60
      return "#{minutes} minutes ago"
    elsif minutes < 1440
      hours = minutes / 60
      minutes = minutes - (hours * 60)
      return "#{hours} hours and #{minutes} minutes ago"
    else
      days = ((minutes / 60) / 24).floor
      return "about #{days} days ago"
    end
  end

  def as_json(option = {})
    {
      :body => sanitized_body,
      :parent_id => parent_id,
      :id => id,
      :text_id => text_id,
      :author => screen_name,
      :sentence_checksum => sentence_checksum,
      :sentence => sentence_body,
      :age =>  calculate_age,
      :timestamp => created_at.to_i
    }
  end

  class << self
    def parent_ids
      unscoped.where.not(parent_id: nil).select(:parent_id)
    end

    def probably_spam
      body = arel_table[:body]

      no_spaces = body.does_not_match('% %')

      punctuation = %w[. ? !].map { |p| ?% + p + ?% }

      no_punctuation = body.matches_any(punctuation).not

      where(no_spaces.and(no_punctuation)).anonymous.not_part_of_a_thread
    end
  end
end
