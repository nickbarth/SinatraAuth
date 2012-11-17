class EmailSubscriber
  attr_accessor :user
  attr_accessor :logger

  # Inject the user class.
  def initialize(user)
    @user = user
    @logger = Logger.new(STDOUT)
  end

  # Asynchronously queue a welcome email for a user.
  def welcome_email
    logger.debug 'User welcome email sent.'
  end
  # Asynchronously queue a password reset email for a user.
  def reset_email
    logger.debug 'User reset email sent.'
  end
end
