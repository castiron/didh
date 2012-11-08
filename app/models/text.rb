class Text < ActiveRecord::Base
  attr_accessible :body, :pub_date, :title, :abstract, :notes, :bibliography
  has_many :sentences
  has_many :authors
  has_many :index_words
end
