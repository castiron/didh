module Concerns
  # Methods that can isolate an interaction within a single transaction, and provide easy
  # short-circuiting.
  module IsolatableInteraction
    extend ActiveSupport::Concern

    include Concerns::ConfigurableInteraction
    include Concerns::FlattenedErrors

    included do
      configurable_attr :watches_for_halt, false, predicate: true
      configurable_attr :wrap_in_transaction, false, predicate: true
      configurable_attr :always_start_new_transaction, false, predicate: true

      set_callback :validate, :around, :catch_halt!, if: :watches_for_halt?

      set_callback :execute, :around, :in_transaction, if: :wrap_in_transaction?
      set_callback :execute, :around, :catch_halt!, if: :watches_for_halt?
    end

    # Used to differentiate `nil` as a valid `on_success` argument.
    NO_ARG = Dux.null 'No Argument Passed'

    # @api private
    # @return [void]
    def catch_halt!
      catch :halt! do
        yield if block_given?
      end
    end

    # @param [ApplicationRecord, ActiveModel::Validations, #destroy] model
    # @return [void]
    def destroy_model!(model)
      unless model.destroy
        failure_reason = flatten_errors_for(model).presence || "Unable to destroy model"

        halt! failure_reason
      end

      return model
    end

    # @param [String] reason
    # @return [void]
    def halt!(reason = nil)
      errors.add :base, reason if reason.present?

      throw :halt!
    end

    # @param [ApplicationRecord, ActiveModel::Validations] model
    # @return [ApplicationRecord]
    def halt_on_invalid!(model)
      halt! flatten_errors_for(model) unless model.valid?

      return model
    end

    def persist_model!(model, assimilate: false, save_context: nil)
      save_options = {}.tap do |h|
        h[:context] = save_context if save_context.present?
      end

      return model if model.save(save_options)

      if assimilate
        assimilate_errors!(model)

        if errors.none?
          halt! "Model failed to save"
        else
          halt!
        end
      else
        halt! flatten_errors_for(model)
      end
    end

    # @api private
    # @param [ApplicationRecord]
    # @return [void]
    def assimilate_errors!(model)
      return unless model.errors.any?

      model.errors.each do |attribute, message|
        if input?(attribute)
          errors.add attribute, message
        else
          errors.add :base, model.errors.full_message(attribute, message)
        end
      end
    end

    # @api private
    # @param [#model_name, ApplicationRecord]
    # @return [Symbol]
    def error_target_for(model, default: :base)
      key = model&.model_name&.i18n_key

      key && input?(key.to_sym) ? key : default
    end

    # @api private
    # @return [ActiveRecord::WrappedTransaction::Result]
    def in_transaction_with_result(start_new: always_start_new_transaction?, &block)
      ApplicationRecord.wrapped_transaction(joinable: !start_new, requires_new: start_new, &block)
    end

    # @api private
    # @param [Object] on_success We use {NO_ARG} here to differentiate vs `nil`.
    # @yield The execution method for this interaction
    # @return [Object]
    def in_transaction(on_success: NO_ARG, on_failure: :halt, &block)
      txn_result = in_transaction_with_result(&block)

      if txn_result.success?
        on_success.eql?(NO_ARG) ? txn_result.result : on_success
      elsif on_failure == :halt
        if errors.none?
          if txn_result.error.present?
            err = txn_result.error
            binding.pry
            errors.add :base, "Error caused rollback: #{txn_result.error.inspect}"
          else
            errors.add :base, "Uncaught rollback"
          end
        end

        return false
      else
        on_failure
      end
    end

    class_methods do
      def always_start_new_transaction!(value = true)
        self.always_start_new_transaction = value
      end

      # Make an interaction easily haltable.
      #
      # @return [void]
      def haltable!
        self.watches_for_halt = true
      end

      # Specify that the interaction should run in a transaction.
      #
      # @see .haltable implies that the interaction can be halted
      #
      # @return [void]
      def transactional!
        haltable!

        self.wrap_in_transaction = true
      end
    end
  end
end
