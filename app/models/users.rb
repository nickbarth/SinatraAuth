class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates_format_of :email, :with => /@.+\./

  # Finds a user by their auth token and email
  def self.find_by_reset(email, auth_token)
    find_by_email_and_auth_token(email, auth_token).tap do |user|
      user.update_attribute(:auth_token, SecureRandom.urlsafe_base64) if user.present?
    end
  end

  # Creates a new user
  def self.create_subscriber(user)
    User.new email:      user[:email],
             password:   user[:password],
             auth_token: SecureRandom.urlsafe_base64
  end

  # Updates the users settings
  def update_settings(settings)
    self.email = settings[:email]
    self.password = settings[:password] unless settings[:password].empty?
    save
  end
end
