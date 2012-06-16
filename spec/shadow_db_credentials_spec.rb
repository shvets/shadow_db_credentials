require 'spec_helper'

require 'shadow_db_credentials'
require 'yaml'

describe ShadowDbCredentials do
  it "should read credentials from the file" do
    YAML.expects(:load_file).with("#{ENV['HOME']}/.credentials/rails_app_tmpl").returns(
        {"url" => "some_url", "username" => "username", "password" => "password"}
    )

    subject = ShadowDbCredentials.new("#{ENV['HOME']}/.credentials")

    configurations = {'production' => { 'adapter' => 'oracle_enhanced', 'credentials' => 'rails_app_tmpl'}}

    result = subject.process_all_configurations configurations

    result["production"]["url"].should == 'some_url'
  end
end