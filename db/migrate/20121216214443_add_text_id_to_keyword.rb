class AddTextIdToKeyword < ActiveRecord::Migration
  def change
    add_column :keywords, :text_id, :integer
  end
end
