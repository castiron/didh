module ManifoldExport
  class Perform < ActiveInteraction::Base
    include Concerns::ExportService

    attr_reader :export_data

    # @return [Hash]
    def execute
      UserIpMapping.refresh
      SentenceMapping.refresh

      @export_data = {}.with_indifferent_access

      export_data[:users] = User.all.map do |user|
        compose ManifoldExport::ExportUser, user: user
      end

      export_data[:texts] = Edition.all.map do |edition|
        {
          source_id: edition.id.to_s,
          label: edition.label
        }.tap do |h|
          h[:selections] = compose_collection ManifoldExport::ExportSelection, SentenceMapping.exportable.by_edition(edition)
        end
      end

      Rails.root.join('manifold-export.json').open 'w+' do |f|
        f.write export_data.to_json
      end

      return export_data
    end
  end
end
