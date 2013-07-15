class AddAuthorNameAndAuthorEmailToComments < ActiveRecord::Migration
  def change
    add_column :comments, :author_name, :string
    add_column :comments, :author_email, :string
  end
end
