class AddPartIdToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :part_id, :integer
  end
end
