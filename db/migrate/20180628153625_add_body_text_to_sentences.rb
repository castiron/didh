class AddBodyTextToSentences < ActiveRecord::Migration
  def change
    add_column :sentences, :body_text, :text, default: '', null: false

    reversible do |dir|
      dir.up do
        say_with_time 'Populating body text' do
          counter = 0

          Sentence.reset_column_information

          Sentence.find_each do |sentence|
            body_text = Nokogiri::HTML.fragment(sentence.body).inner_text.strip

            sentence.update_column :body_text, body_text

            counter += 1
          end

          counter
        end
      end
    end
  end
end
