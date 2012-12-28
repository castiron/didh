class AddIsStaticToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :is_static, :boolean
  end
end
