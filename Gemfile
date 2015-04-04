source 'https://rubygems.org'

ruby '2.2.0'

# Rails
gem 'rails', '4.2.0'

# DB adapter
gem 'pg'
gem 'migration_comments'

# Daemon controls
gem 'sidekiq'

# Parsing tools
gem 'youtube_it'

group :development do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rvm', '~> 0.1.0'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets', '~> 1.0.3'
  gem 'annotate'
end

group :test do
  # TDD
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  # Test coverage
  gem 'simplecov', require: false
  # Fake data
  gem 'factory_girl_rails'
  gem 'lorem-ipsum'
  # Fixtures cleaner
  gem 'database_cleaner'
  # HTTP stub
  gem 'webmock'
  gem 'sinatra'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'faker'
  gem 'spring'
end

group :doc do
  gem 'sdoc', require: false
end

