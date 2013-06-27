class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :parent_id
      t.integer :text_id
      t.string :sentence_checksum
      t.text :body

      t.timestamps
    end
  end
end
