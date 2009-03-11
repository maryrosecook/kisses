require 'digest/sha1'

class User < ActiveRecord::Base
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 1..100
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_presence_of     :password,                    :if => :password_required?
  validates_length_of       :password, :within => 1..100, :if => :password_required?
  validates_confirmation_of :password,                    :if => :password_required?
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation

  def self.new_fake_and_save()
    user = self.new()
    user.fake = 1
    user.generate_temporary_email()
    user.audiography = Audiography.new_fake_and_save(user)
    raise user.inspect if !user.save()
    
    user
  end

  def self.email_available?(email)
    !self.find(:first, :conditions=>['email = ?', email])
  end

  def generate_temporary_email()
    base_email = "temporary"
    email_try = base_email
    
    i = 1
    while(!User.email_available?(email_try) && !Audiography.url_title_available?(email_try))
      email_try = base_email + i.to_s
      i += 1
    end
    
    self.email = email_try
  end

  # creates a unique username based on user's email
  def create_username() #t
    email_username = self.email.gsub(/(\A([\w\.\-\+]+))@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, "\\1")
    email_username = email_username.gsub(/\W/, "")
    username_try = email_username
    
    i = 1
    found_unique_username = false
    while(!found_unique_username)
      if User.unique_username?(nil, username_try)
        found_unique_username = true
      else
        username_try = email_username + i.to_s
      end
      i += 1
    end
    
    self.username = username_try
  end

  # returns true if passed username is unique
  def self.unique_username?(user, username) #t
    unique = false
    if user # user already created so exclude them from search
      unique = self.find(:all, :conditions => "id != #{user.id} && username = '#{username}'").length == 0
    else
      unique = !User.find_by_username(username)
    end
    
    unique
  end

  def self.get_real()
    self.find(:all, :conditions => "fake != 1")
  end
  
  def self.get_fake()
    self.find(:all, :conditions => "fake = 1")
  end

  def real?()
    self.fake != 1
  end
  
  def fake?()
    self.fake == 1
  end
  
  def admin?()
    self.admin == 1
  end

  # Authenticates a user by their username and unencrypted password.  Returns the user or nil.
  def self.authenticate(identifier, password) #nt
    u = self.find_user(identifier) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def self.find_user(identifier) #nt
    u = find_by_email(identifier)
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      real? && (crypted_password.blank? || !password.blank?)
    end
end