class FixBodySize < ActiveRecord::Migration
  def up
    change_column :sentences, :body, :text
  end

  def down
  end
end
