source 'https://rubygems.org'

gem 'sinatra'
gem 'haml'
gem 'thin'
gem 'data_mapper'

group :development, :test do
  gem 'shotgun'
  gem 'dm-sqlite-adapter'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :production do
  gem 'dm-postgres-adapter'
end
