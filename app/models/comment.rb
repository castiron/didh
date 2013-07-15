class Comment < ActiveRecord::Base


  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::SanitizeHelper


  belongs_to :text
  belongs_to :user

  attr_accessible :body, :parent_id, :sentence_checksum, :text_id, :user_id, :author_name, :author_email
  has_many :children, :class_name => 'Comment', :foreign_key => 'parent_id', :dependent => :destroy

  validates :body, :sentence_checksum, presence: true
  validates :parent_id, numericality: true, allow_nil: true
  validates :user_id, numericality: true, allow_nil: true

  with_options unless: :user_id? do |comment|
    comment.validates :author_name, :author_email, presence: true
  end


  def sanitized_body
    simple_format(sanitize(body, tags: %w(strong, em)))
  end

  def screen_name()
		if user
			if user.alias
				user.alias
			elsif user.name
				user.name
			else
				'no name'
      end
    elsif author_name
      author_name
		else
			'anonymous'
		end
  end

  def calculate_age()
    minutes = ((Time.now- created_at.to_time) / 60).ceil
    if minutes < 1
      return "less than 1 minute ago"
    elsif minutes < 60
      return "#{minutes} minutes ago"
    elsif minutes < 1440
      hours = minutes / 60
      minutes = minutes - (hours * 60)
      return "#{hours} hours and #{minutes} minutes ago"
    else
      days = ((minutes / 60)/24).floor
      return "about #{days} days ago"
    end
  end

  def as_json(option = {})
    {
        :body => sanitized_body,
        :parent_id => parent_id,
        :id => id,
        :text_id => text_id,
        :author => screen_name(),
        :sentence_checksum => sentence_checksum,
        :age =>  calculate_age(),
        :timestamp => created_at.to_i
    }
  end

end
