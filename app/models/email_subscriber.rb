class EmailSubscriber
  attr_accessor :user

  # Inject the user class.
  def initialize(user)
    @user = user
  end

  # Asynchronously queue a welcome email for a user.
  def welcome_email
    # User welcome email sent.
  end

  # Asynchronously queue a password reset email for a user.
  def reset_email
    # User reset email sent.
  end
end
