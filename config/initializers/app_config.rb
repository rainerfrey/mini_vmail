require 'erb'
require 'yaml'

class SimpleConfigLoader
  def self.load(file)
    return {} unless File.exists? file
    rawconfig = ERB.new(File.read(file)).result
    config = YAML.load(rawconfig)[Rails.env]
    deep_symbolize_keys(config)
  end
  
  def self.deep_symbolize_keys(hash)
    return hash unless hash.is_a?(Hash)
    hash.inject({}) do |options, (key, value)|
      value=deep_symbolize_keys(value) if value.is_a?(Hash)
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end

APP_CONFIG = SimpleConfigLoader.load("#{Rails.root}/config/config.yml")
