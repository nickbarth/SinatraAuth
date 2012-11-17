require 'bundler'
Bundler.require

class SinatraApp < Sinatra::Base
  configure do
    set :views, 'app/views'
  end
end
