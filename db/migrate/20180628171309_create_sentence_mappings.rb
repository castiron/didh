class CreateSentenceMappings < ActiveRecord::Migration
  def change
    create_view :sentence_mappings, materialized: true

    add_index :sentence_mappings, :sentence_id, unique: true
    add_index :sentence_mappings, :exportable
    add_index :sentence_mappings, :edition_id
    add_index :sentence_mappings, :text_id
  end
end
