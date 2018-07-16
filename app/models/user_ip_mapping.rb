class UserIpMapping < ActiveRecord::Base
  has_many :annotations, primary_key: :ip_address, foreign_key: :ip
  belongs_to :user

  class << self
    # @return [void]
    def refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
    end
  end
end
