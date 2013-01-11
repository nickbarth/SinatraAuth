require './lib/app'
require 'capybara/rspec'
require 'database_cleaner'

module Integration
  module Helpers
    include Capybara::DSL
    Capybara.app = SinatraApp

    def self.included(base)
      base.before(:all){ DatabaseCleaner.clean_with :truncation }
      base.before(:each){ DatabaseCleaner.start }

      base.after(:each) do
        DatabaseCleaner.clean
        if example.exception or page.status_code != 200
          File.open('logs/exception_page.html.log', 'w') do |file|
            file.write page.html
          end
          raise 'Server Exception' if page.status_code != 200
        end
      end
    end
  end
end
