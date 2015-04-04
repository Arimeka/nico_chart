ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'faker'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
    stub_request(:any, /nicovideo.jp/).to_rack(FakeNicoVideo)
    stub_request(:any, /googleapis.com/).to_rack(FakeYouTube)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.expose_current_running_example_as :example
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
