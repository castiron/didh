class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.string :text
      t.integer :text_id
      t.string :hash

      t.timestamps
    end
  end
end
