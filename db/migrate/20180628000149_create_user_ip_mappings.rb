class CreateUserIpMappings < ActiveRecord::Migration
  def change
    create_view :user_ip_mappings, materialized: true

    add_index :user_ip_mappings, :user_id,    unique: true
    add_index :user_ip_mappings, :ip_address, unique: true
  end
end
