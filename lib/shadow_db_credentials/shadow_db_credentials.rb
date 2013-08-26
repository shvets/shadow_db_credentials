require 'erb'
require 'active_support/core_ext/hash/indifferent_access'

class ShadowDbCredentials

  def initialize credentials_dir
    @credentials_dir = credentials_dir
  end

  def retrieve_configuration rails_env, source='config/database.yml'
    file = source.kind_of?(String) ? File.open(source) : source

    template = ERB.new file.read

    config = YAML.load(template.result(binding)).with_indifferent_access

    process_credentials(config[rails_env])
  end

  def process_configurations configurations
    new_configurations = {}

    configurations.each do |name, config|
      new_configurations[name] = process_credentials(config)
    end

    new_configurations.with_indifferent_access
  end

  def process_configuration configurations, rails_env
    new_configurations = configurations.clone

    config = configurations[rails_env]

    new_configurations[rails_env] = process_credentials(config)

    new_configurations
  end

  private

  def process_credentials config
    if config[:credentials]
      credentials = config.delete(:credentials)

      file_name = "#{@credentials_dir}/#{credentials}"

      if File.exist? file_name
        config.merge!(YAML.load_file(file_name).with_indifferent_access)
      else
        puts "Missing credentials file: #{file_name}."
      end
    end

    config
  end

end

