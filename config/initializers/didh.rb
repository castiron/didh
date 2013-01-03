module Didh_Configuration
  def self.[](key)
    unless @config
      raw_config = File.read("#{Rails.root}/config/didh.yml")
      @config = YAML.load(raw_config)[Rails.env].symbolize_keys
    end
    @config[key]
  end

  def self.[]=(key, value)
    @config[key.to_sym] = value
  end
end