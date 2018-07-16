module ManifoldExport
  class ExportUser < ActiveInteraction::Base
    include Concerns::IsolatableInteraction

    transactional!

    object :user

    # @return [Hash]
    def execute
      user.slice(:email, :encrypted_password).tap do |h|
        h[:source_id] = user.id.to_s
        h[:nickname] = user.alias.presence || generate_nickname

        if first_name?
          h[:first_name] = first_name

          if last_name?
            h[:last_name] = last_name
          else
            h[:last_name] = '<Unspecified By Import>'
          end
        else
          h[:first_name] = 'Imported'
          h[:last_name] = 'User'
        end
      end
    end

    private

    def first_name
      parsed_name[:first_name]
    end

    def first_name?
      first_name.present?
    end

    def last_name
      parsed_name[:last_name]
    end

    def last_name?
      last_name.present?
    end

    def parse_name
      return {} unless user.name?

      parsed, *_ = Namae.parse(user.name)

      { first_name: parsed&.given, last_name: parsed&.family }.compact
    end

    attr_lazy_reader :parsed_name do
      parse_name
    end

    def generate_nickname
      if user.alias?
        user.alias
      elsif first_name?
        first_name
      else
        user.email
      end
    end
  end
end
