require 'spec_helper'

require 'shadow_db_credentials'
require 'yaml'

describe ShadowDbCredentials do
  it "should read credentials from the file" do
    credentials_dir = 'some_credentials_dir'
    credentials_file_name = "#{credentials_dir}/rails_app_tmpl"

    YAML.expects(:load_file).with(credentials_file_name).returns(
        {url: "some_url", username: "username", password: "password"}
    )
    File.expects(:exist? => true).with(credentials_file_name)

    subject = ShadowDbCredentials.new(credentials_dir)

    configurations = {production: { adapter: 'oracle_enhanced', credentials: 'rails_app_tmpl'}}

    result = subject.process_all_configurations configurations

    result[:production][:url].should == 'some_url'
  end
end