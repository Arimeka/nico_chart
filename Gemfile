source 'https://rubygems.org'

ruby '2.2.0'

# Rails
gem 'rails', '4.2.0'

# Pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# DB adapter
gem 'pg'
gem 'migration_comments'

# Daemon controls
gem 'sidekiq'

# Parsing tools
gem 'mechanize'

# CSS
gem 'sass-rails', '~> 5.0'
# HTML
# == Templates
gem 'haml-rails'

# JS
# == Server-side JS execution
gem 'therubyracer'
# == JS  compressor & minification tools
gem 'uglifier', '>= 1.3.0'
# == CoffeeScript
gem 'coffee-rails', '~> 4.1.0'
# == JQuery
gem 'jquery-rails'
# JSON API builder
gem 'jbuilder', '~> 2.0'

# Bootstrap
gem 'bundler', '>= 1.7.0'
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-sass'
  gem 'rails-assets-startbootstrap-sb-admin-2'
end

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

group :production do
  gem 'unicorn'
end

