class FixBody < ActiveRecord::Migration
  def up
    rename_column :sentences, :text, :body
  end

  def down
  end
end
