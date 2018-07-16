class AddPositionToSentences < ActiveRecord::Migration
  def change
    add_column :sentences, :position, :integer
    add_column :sentences, :excluded_from_export, :boolean, default: false

    add_index :sentences, %i[text_id position], unique: true, where: %[position IS NOT NULL]
    add_index :sentences, :excluded_from_export

    reversible do |dir|
      dir.up do
        say_with_time 'Updating sentence positions' do
          Text.includes(:sentences).each do |text|
            text.sentence_positions.each do |(checksum, position)|
              text.sentences.where(checksum: checksum).update_all position: position
            end

            text.errant_sentences.each do |sentence|
              sentence.update_column :excluded_from_export, true
            end
          end
        end
      end
    end
  end
end
