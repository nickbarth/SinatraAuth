class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates_format_of :email, :with => /@.+\./

  # Finds a user by their reset token and email
  def self.find_by_reset(email, reset_token)
    current_user = find_by_email_and_reset_token(email, reset_token)
    if current_user.present? and current_user.reset_time > 5.minutes.ago
      current_user
    else
      nil
    end
  end

  # Creates a new user
  def self.create_subscriber(user)
    User.new email:       user[:email],
             password:    user[:password]
  end

  # Updates the users settings
  def update_settings(settings)
    self.email = settings[:email]
    self.password = settings[:password] unless settings[:password].empty?
    save
  end
end
