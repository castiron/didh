class Author < ActiveRecord::Base
	has_many :texts, through: :authors_texts
  has_many :authors_texts
end
