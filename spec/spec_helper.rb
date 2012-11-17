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
