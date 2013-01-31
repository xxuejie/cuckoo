require 'digest/sha1'

module Helpers
  SALT_LEN = 10
  SALT_DICT = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a

  def self.generate_salt
    salt = ""
    SALT_LEN.times {salt << SALT_DICT[rand(SALT_DICT.length - 1)]}
    salt
  end

  def self.encrypt_password(password, salt)
    # Note: well, I planned to use PBKDF2(https://github.com/emerose/pbkdf2-ruby)
    # here, but too bad RubyGems is done. I will just first go with sha1 and move
    # to PBKDF2 later
    Digest::SHA1.hexdigest(password + salt)
  end

  module LoginHelpers
    # Check if the user is currently logged in, and if not, redirect to login page
    def check_login!
      unless session[:user]
        redirect to('/signin.html')
      end
    end
  end
end
