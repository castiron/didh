class AddBibliographyToText < ActiveRecord::Migration
  def change
    add_column :texts, :bibliography, :text
  end
end
