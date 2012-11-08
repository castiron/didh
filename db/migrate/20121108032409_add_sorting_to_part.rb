class AddSortingToPart < ActiveRecord::Migration
  def change
    add_column :parts, :sorting, :integer
  end
end
