class AdjustChecksumFields < ActiveRecord::Migration
  def up
    add_column :comments, :sentence_checksum_new, :integer
    Comment.reset_column_information
    Comment.all.each do |comment|
      comment.sentence_checksum_new = comment.sentence_checksum
      comment.save
    end

    remove_column :comments, :sentence_checksum
    rename_column :comments, :sentence_checksum_new, :sentence_checksum
  end

  def down
  end
end
