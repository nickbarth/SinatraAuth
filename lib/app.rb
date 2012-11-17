require './lib/config'

class SinatraApp
  # Home Page
  get '/' do
    haml :index
  end

  # Sign Up Page
  get '/join' do
    haml :join
  end

  # Receive Sign Up Request
  post '/join' do
    @current_user = User.create_subscriber(params[:user])
    if current_user.save
      EmailSubscriber.new(current_user).welcome_email
      session[:user_id] = current_user.id
      flash[:notice] = 'Thank you for becoming a member.'
      redirect to('/members')
    else
      flash[:notice] = 'Invalid email address or password.'
      redirect to('/join')
    end
  end

  # Login Page
  get '/login' do
    haml :login
  end

  # Receive Login Request
  post '/login' do
    user = User.find_by_email(params[:user][:email])
    if user and user.try(:authenticate, params[:user][:password])
      session[:user_id] = user.id
      flash[:notice] = 'Successfully logged in.'
      redirect to('/members')
    else
      flash[:notice] = 'Invalid email address or password.'
      redirect to('/login')
    end
  end

  # Log Out Page
  get '/logout' do
    flash[:notice] = 'Successfully logged out.'
    session.clear
    redirect to('/')
  end

  # Reset Password Page
  get '/reminder' do
    haml :reminder
  end

  # Receive Reset Password Request
  post '/reminder' do
    @current_user = User.find_by_email(params[:user][:email])
    EmailSubscriber.new(current_user).reset_email if current_user
    flash[:notice] = 'Your password reset email has been sent.'
    redirect to('/reminder')
  end

  # New Password Page
  get '/reset/:email/:auth_token' do
    @current_user = User.find_by_reset(params[:email], params[:auth_token])
    if current_user
      session[:user_id] = current_user.id
      haml :reset
    else
      raise 'Invalid email or auth token.'
    end
  end

  # Receive Password Update Request
  post '/reset' do
    current_user.update_attribute :password, params[:user][:password]
    flash[:notice] = 'Password updated.'
    redirect to('/members')
  end

  # Members Only Page
  get '/members' do
    haml :index
  end

  # User Settings Page
  get '/members/account' do
    haml :account
  end

  # Receive New User Settings
  post '/members/account' do
    current_user.update_settings(params[:user])
    flash[:notice] = 'Your settings have been updated.'
    redirect to('/account')
  end
end
