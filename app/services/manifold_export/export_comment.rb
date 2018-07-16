module ManifoldExport
  class ExportComment < ActiveInteraction::Base
    include Concerns::ExportService

    object :comment

    def execute
      comment.slice(:body, :created_at, :updated_at).tap do |h|
        h[:anonymous] = comment.user_id.blank?
        h[:user_id]   = comment.user_id&.to_s
        h[:comments]  = compose_collection ManifoldExport::ExportComment, comment.children.exportable
      end
    end
  end
end
