source 'https://rubygems.org'

gem 'sinatra'
gem 'haml'
gem 'thin'
gem 'data_mapper'
gem 'omniauth-twitter'
gem 'rack-flash3'

group :development, :test do
  gem 'shotgun'
  gem 'dotenv'
  gem 'dm-sqlite-adapter'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'database_cleaner', git: "git@github.com:bmabey/database_cleaner.git" # need fix to issue 244
  gem 'dm-rspec'
end

group :production do
  gem 'dm-postgres-adapter'
end
