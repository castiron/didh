class AddAbstractToText < ActiveRecord::Migration
  def change
    add_column :texts, :abstract, :text
  end
end
