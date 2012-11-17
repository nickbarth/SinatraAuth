require './lib/config'

class SinatraApp
  # Home Page
  get '/' do
    haml :index
  end
end
