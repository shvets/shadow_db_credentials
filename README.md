# Shadow DB Credentials

## Helps to keep DB credentials for rails app in private place

## Installation

Add this line to to your Gemfile:

    gem "shadow_db_credentials"

And then execute:

    $ bundle

## Usage

Create "shadowed" credentials file (**your_prod_credentials**) inside some directory (e.g. **~/.credentials**):

```yml
username: your_username
password: your_password
```

The location of your **credentials directory** is controlled by **CREDENTIALS_DIR** environment
variable. Register it in **config/initializers/env_variables.rb** file:

```ruby
ENV['CREDENTIALS_DIR'] ||= "#{ENV['HOME']}/.credentials"
```

If you want to have different **credentials directory** per environment, define it in corresponding env file:

```ruby
# config/environments/development.rb
...
ENV['CREDENTIALS_DIR'] ||= "#{ENV['HOME']}/.credentials"
```

Remove all the credentials (username/password) that you don't want to keep inside **config/database.yml**
and replace them with single **credentials** attriubute. It points to the name of credentials file
(**your_prod_credentials**):

```yml
development:
  adapter: postgresql
  database: your_dev_db
  credentials: your_dev_credentials

production:
  adapter: postgresql
  database: your_prod_db
  credentials: your_prod_credentials
```

If you want, you can also move other sensitive information, such as database name, url etc.

Next, you have to create code hook inside rails **config/application.rb** in order to call gem's API:

```ruby
require 'shadow_db_credentials'

...

module YourRailsApp
  class Application < Rails::Application
    ...

    def config.database_configuration
      orig_db_configurations = super

      processor = ShadowDbCredentials.new(ENV['CREDENTIALS_DIR'])

      processor.process_configurations(orig_db_configurations)
    end
  end
end
```

The hook will access original DB configuration and try to expand all **credentials** attributes
with corresponding values dynamically, at run time.

If you think that processing all environments is not necessary, you cant process only current environment:

```ruby
module YourRailsApp
  class Application < Rails::Application
    ...

    def config.database_configuration
      orig_db_configurations = super

      processor = ShadowDbCredentials.new(ENV['CREDENTIALS_DIR'])

      processor.process_configuration(orig_db_configurations, Rails.env)
    end
  end
end
```

You can check result of your work:

```bash
$ rails console production

> ActiveRecord::Base.configurations["production"]
 => {"adapter"=>"postgresql", "username"=>"your_username", "password"=>"your_password"}

> Rails.application.config.database_configuration['production']
 => {"adapter"=>"postgresql", "username"=>"your_username", "password"=>"your_password"}
```

Or you can get it with API call:

```ruby
require 'shadow_db_credentials'

credentials_dir = ENV['CREDENTIALS_DIR']
processor = ShadowDbCredentials.new(credentials_dir)

# 1. get production hash, read configuration from default location

prod_conf = processor.retrieve_configuration "production"
prod_conf.inspect

# 2. get development hash, read configuration from dynamic source

source = StringIO.new <<-TEXT
  development:
    adapter: postgresql
    credentials: your_dev_db
TEXT

dev_conf = processor.retrieve_configuration 'development', source
dev_conf.inspect
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

