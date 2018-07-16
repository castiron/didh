module Concerns
  module ExportService
    extend ActiveSupport::Concern

    include Concerns::IsolatableInteraction

    included do
      transactional!
    end

    def compose_collection(interaction, collection = nil, as: nil)
      collection ||= yield if block_given?

      raise "Must specify collection or provide in a block" if collection.nil?

      as ||= collection.model_name.i18n_key

      collection.map do |model|
        compose interaction, as => model
      end
    end
  end
end
