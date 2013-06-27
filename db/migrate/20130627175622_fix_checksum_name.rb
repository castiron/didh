class FixChecksumName < ActiveRecord::Migration
  def up
    rename_column :sentences, :hash, :checksum
  end

  def down
  end
end
