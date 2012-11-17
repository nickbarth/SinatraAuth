require './lib/app'
require 'capybara/rspec'
require 'database_cleaner'

module Integration
  module Helpers
    include Capybara::DSL
    Capybara.app = SinatraApp
    Capybara.save_and_open_page_path = 'logs/'

    def self.included(base)
      base.before(:all){ DatabaseCleaner.clean_with :truncation }
      base.before(:each){ DatabaseCleaner.start }
      base.after(:each){ DatabaseCleaner.clean }
    end
  end
end
