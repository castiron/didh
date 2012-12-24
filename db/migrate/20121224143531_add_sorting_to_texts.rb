class AddSortingToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :sorting, :integer
  end
end
