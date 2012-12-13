class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.references :text
      t.integer :sentence
      t.datetime :datetime
      t.string :ip
      t.integer :type

      t.timestamps
    end
    add_index :annotations, :text_id
  end
end
