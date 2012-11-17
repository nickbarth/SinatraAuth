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

  # Adds a site under the current user
  def add_site(site)
    unless site[/http:\/\//].present? or site[/https:\/\//].present?
      site[:url] = "http://#{site[:url]}"
    end
    sites.create(url: site[:url], host: URI(site[:url]).host)
  end

  # Updates the users settings
  def update_settings(settings)
    email = settings[:email]
    password = settings[:password] unless settings[:password].empty?
    save
  end
end
