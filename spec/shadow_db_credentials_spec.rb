require 'spec_helper'

require 'shadow_db_credentials'
require 'yaml'

describe ShadowDbCredentials do
  before do
    @credentials_dir = 'some_credentials_dir'

    credentials_file_name = "#{@credentials_dir}/your_dev_db"

    YAML.expects(:load_file).with(credentials_file_name).returns(
      {url: 'some_url', username: 'username', password: 'password'}
    )
    File.expects(:exist? => true).with(credentials_file_name)
  end

  subject do
    ShadowDbCredentials.new(@credentials_dir)
  end

  it 'processes credentials attrubute' do
    configurations = {production: { adapter: 'oracle_enhanced', credentials: 'your_dev_db'}}

    result = subject.process_configurations configurations

    expect(result[:production][:url]).to eq 'some_url'
    expect(result['production']['url']).to eq 'some_url'
  end

  it 'retrieves given configuration' do
    source = StringIO.new <<-TEXT
development:
  adapter: postgresql
  credentials: your_dev_db
TEXT

    result = subject.retrieve_configuration 'development', source

    expect(result[:url]).to eq 'some_url'
  end
end
