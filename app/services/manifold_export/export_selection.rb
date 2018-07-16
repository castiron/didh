module ManifoldExport
  class ExportSelection < ActiveInteraction::Base
    include Concerns::ExportService

    object :sentence_mapping

    # @return [Hash]
    def execute
      sentence_mapping.slice(:previous_text, :previous_body, :body, :next_body, :next_text).tap do |h|
        h[:comments] = compose_collection ManifoldExport::ExportComment, sentence_mapping.comments.roots
        h[:highlights] = compose_collection ManifoldExport::ExportHighlight, sentence_mapping.annotations.includes(:user)
      end
    end
  end
end
