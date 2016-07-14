class AuthorsText < ActiveRecord::Base
  belongs_to :author
  belongs_to :text

  def to_s
    "AuthorsText #{id}: #{author.name} (#{author.id}), #{text.title} (#{text.id}), sorting: #{sorting}"
  end
end
