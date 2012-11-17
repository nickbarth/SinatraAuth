require 'bundler'
Bundler.require

require 'logger'
require './db/connection'
require './app/models/users'

class SinatraApp < Sinatra::Base
  before { ActiveRecord::Base.verify_active_connections! }
  after  { ActiveRecord::Base.clear_active_connections! }

  configure :development do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  configure do
    enable :sessions
    use Rack::Flash
    set :views, 'app/views'
  end
end
