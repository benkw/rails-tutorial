class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email # this includes object creation and updates
  before_create :create_activation_digest # method reference --> rails looks for a method called create_activation_digest and run before creating the user
  validates(:name, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255 }, 
                                    format: { with: VALID_EMAIL_REGEX }, 
                                    uniqueness: { case_sensitive: false })
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
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") # inside user model so can omit self
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
    # the remember_token argument in this method is not the same as the one defined with attr_accessor :remember token
    # it is a variable local to the method
    
    # metaprogramming - send method lets us call a method by "sending a message"
    # user.send("#{attribute}_digest")
  end
  
  # forgets a user, allowing them to logout
  def forget
    update_attribute(:remember_digest, nil)  
  end
  
  # activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
  end
  
  # sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # defines a proto-feed
  def feed
    # following_ids method is made by Active Record based on the has_many :following association
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  private
    
    # converts email to all lower case
    def downcase_email
      self.email = email.downcase
    end
    
    # create the token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  
end