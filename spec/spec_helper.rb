require './lib/app'
require 'capybara/rspec'
require 'database_cleaner'

module Integration
  module Helpers
    include Capybara::DSL
    Capybara.app = SinatraApp
    Capybara.save_and_open_page_path = 'logs/'
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
