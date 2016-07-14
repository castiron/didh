class AddSortingToAuthorsText < ActiveRecord::Migration
  def change
    add_column :authors_texts, :sorting, :integer, default: 0
  end
end
