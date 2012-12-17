class AddSentenceToKeywords < ActiveRecord::Migration
  def change
    add_column :keywords, :sentence, :integer
  end
end
