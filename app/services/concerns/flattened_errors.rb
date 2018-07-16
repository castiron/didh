module Concerns
  module FlattenedErrors
    # @return [String]
    def flattened_errors
      flatten_errors_for self
    end

    # @param [ActiveModel::Validations] object
    # @return [String]
    def flatten_errors_for(object)
      object.errors.full_messages.to_sentence.upcase_first
    end
  end
end
