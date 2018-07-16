module ManifoldExport
  class ExportHighlight < ActiveInteraction::Base
    include Concerns::ExportService

    object :annotation

    def execute
      annotation.slice(:created_at, :updated_at).tap do |h|
        h[:anonymous] = annotation.user.blank?
        h[:user_id]   = annotation.user_id&.to_s
      end
    end
  end
end
