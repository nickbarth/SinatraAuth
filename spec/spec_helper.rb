require './lib/app'
require 'capybara/rspec'

module DatabaseHelper
  def db_type
    ActiveRecord::Base.connection.instance_variable_get(:@config)[:adapter].to_sym
  end
end

module Integration
  module Helpers
    include Capybara::DSL
    include DatabaseHelper
    Capybara.app = SinatraApp
    def self.included(base)
      base.after(:each) do
        ActiveRecord::Base.descendants.each do |table|
          ActiveRecord::Base.connection.execute(->{
            case db_type
            when :sqlite3
              "DELETE from #{table.to_s.pluralize.downcase};
               DELETE from SQLITE_SEQUENCE where NAME=#{table.to_s.pluralize.downcase};"
            when :mysql
              "TRUNCATE TABLE #{table.to_s.pluralize.downcase};"
            end
          }.call)
        end
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

module Model
  module Helpers
    include DatabaseHelper

    def self.included(base)
      base.after(:all) do
        ActiveRecord::Base.descendants.each do |table|
          ActiveRecord::Base.connection.execute(->{
            case db_type
            when :sqlite3
              "DELETE FROM #{table.to_s.pluralize.downcase};
               DELETE from SQLITE_SEQUENCE where NAME=#{table.to_s.pluralize.downcase};"
            when :mysql
              "TRUNCATE TABLE #{table.to_s.pluralize.downcase};"
            end
          }.call) rescue 1
        end
      end
    end
  end
end
