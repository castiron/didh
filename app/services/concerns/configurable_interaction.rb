module Concerns
  # Exposes class-level configurations for various interaction concerns
  module ConfigurableInteraction
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Configurable

      config_accessor :configurable_attrs

      self.configurable_attrs = []
    end

    class_methods do
      # @param [Symbol] name
      # @param [Object] default
      # @param [Boolean] delegates
      # @param [Boolean] predicate
      # @return [void]
      def configurable_attr(name, default = nil, delegates: true, predicate: false)
        name = name.to_sym

        self.configurable_attrs |= [name]

        config_accessor name

        __send__ "#{name}=", default

        if delegates
          delegate name, to: :class

          if predicate
            class_eval <<~RUBY, __FILE__, __LINE__ + 1
            def self.#{name}?
              self.#{name}.present?
            end

            def #{name}?
              self.class.#{name}.present?
            end
            RUBY
          end
        end
      end
    end
  end
end
