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

    configurations.each do |name, params|
      new_configurations[name] = process_credentials(indifferent_access(params))
    end

    new_configurations
  end

  private

  def process_credentials params
    if params[:credentials]
      credentials = params.delete(:credentials)

      file_name = "#{@credentials_dir}/#{credentials}"

      if File.exist? file_name
        params.merge!(indifferent_access(YAML.load_file(file_name)))
      else
        puts "Missing credentials file: #{file_name}."
      end
    end

    params
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

