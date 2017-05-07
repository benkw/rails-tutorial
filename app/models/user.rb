class User < ApplicationRecord
  attr_accessor :remember_token
  
  before_save { email.downcase! }
  validates(:name, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255 }, 
                                    format: { with: VALID_EMAIL_REGEX }, 
                                    uniqueness: { case_sensitive: false })
  validates(:password_confirmation, presence: true, length: { minimum: 6 })
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  
  # returns the has digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                   BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the dataase for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # the remember_token argument in this method is not the same as the one defined with attr_accessor :remember token
    # it is a variable local to the method
  end
  
  # forgets a user, allowing them to logout
  def forget
    update_attribute(:remember_digest, nil)  
  end
  
end