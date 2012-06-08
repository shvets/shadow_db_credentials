class ShadowDbCredentials

  def initialize credentials_dir
    @credentials_dir = credentials_dir
  end

  def retrieve_configuration rails_env, source='config/database.yml'
    file = source.kind_of?(String) ? File.open(source) : source

    template = ERB.new file.read

    config = YAML.load(template.result(binding))

    process_credentials(config[rails_env])
  end

  def process_all_configurations configurations
    new_configurations = {}

    configurations.each do |name, params|
      new_configurations[name] = process_credentials(params)
    end

    new_configurations
  end

  def process_configuration configurations, rails_env
    new_configurations = configurations.clone

    new_configurations[rails_env] = process_credentials(configurations[rails_env])

    new_configurations
  end

  private

  def process_credentials params
    if params['credentials']
      credentials = params.delete('credentials')

      file_name = "#@credentials_dir/#{credentials}"

      if File.exist? file_name
        params.merge!(YAML.load_file(file_name))
      else
        puts "Missing credentials file: #{file_name}."
      end
    end

    params
  end
end

