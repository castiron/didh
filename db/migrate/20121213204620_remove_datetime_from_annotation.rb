class RemoveDatetimeFromAnnotation < ActiveRecord::Migration
  def up
    remove_column :annotations, :datetime
  end

  def down
    add_column :annotations, :datetime, :datetime
  end
end
