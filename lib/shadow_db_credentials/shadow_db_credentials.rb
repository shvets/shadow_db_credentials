require 'erb'

class ShadowDbCredentials

  def initialize credentials_dir
    @credentials_dir = credentials_dir
  end

  def retrieve_configuration rails_env, source='config/database.yml'
    file = source.kind_of?(String) ? File.open(source) : source

    template = ERB.new file.read

    config = indifferent_access(YAML.load(template.result(binding)))

    process_credentials(config[rails_env.to_sym])
  end

  def process_configurations configurations
    new_configurations = {}

    configurations.each do |name, config|
      new_configurations[name] = process_credentials(indifferent_access(config))
    end

    new_configurations
  end

  def process_configuration configurations, rails_env
    new_configurations = configurations.clone

    config = configurations[rails_env]

    new_configurations[rails_env] = process_credentials(indifferent_access(config))

    new_configurations
  end

  private

  def process_credentials config
    if config[:credentials]
      credentials = config.delete(:credentials)

      file_name = "#{@credentials_dir}/#{credentials}"

      if File.exist? file_name
        config.merge!(indifferent_access(YAML.load_file(file_name)))
      else
        puts "Missing credentials file: #{file_name}."
      end
    end

    config
  end

  def indifferent_access hash
    case hash
      when Hash
        Hash[
          hash.map do |k, v|
            [ k.respond_to?(:to_sym) ? k.to_sym : k, indifferent_access(v) ]
          end
        ]
      when Enumerable
        hash.map { |v| indifferent_access(v) }
      else
        hash
    end
  end
end

