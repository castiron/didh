class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.text :body
      t.date :pub_date

      t.timestamps
    end
  end
end
