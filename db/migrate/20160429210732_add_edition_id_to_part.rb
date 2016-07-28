class AddEditionIdToPart < ActiveRecord::Migration
  def change
    add_reference :parts, :edition, index: true, foreign_key: true
  end
end
