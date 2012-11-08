class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :label

      t.timestamps
    end
  end
end
