class ChangeChecksumToInteger < ActiveRecord::Migration
  def up
    remove_column :sentences, :checksum
    add_column :sentences, :checksum, :integer
    Rake::Task['texts:import'].invoke
  end

end
