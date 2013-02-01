require 'digest/md5'
require 'ohm'

require 'helpers/authentication_helper'

class User < Ohm::Model
  attribute :login_name
  index :login_name
  unique :login_name

  attribute :description
  attribute :avatar

  # We only store encrypted password here, authentication
  # is done in helpers/authentication_helper.rb
  attribute :hashed_password
  attribute :salt

  set :followers, :User
  set :following, :User

  collection :tweets, :Tweet

  def validate
    assert_present :login_name
    assert_present :hashed_password
    assert_present :salt
  end

  extend Helpers::Authentication
  extend Helpers::Url

  def self.authenticate(login_name, password)
    u = User.find({login_name: login_name}).first
    return nil if u.nil?
    return u if encrypt_password(password, u.salt) ==
      u.hashed_password
    nil
  end

  def self.create_with_check(atts)
    raise ArgumentError, "Password cannot be empty!" unless atts[:password]
    atts[:salt] = generate_salt
    atts[:hashed_password] = encrypt_password(atts[:password],
                                                       atts[:salt])
    atts.delete(:password)
    atts[:avatar] = normalize_avatar_url(atts[:avatar])

    begin
      u = User.create(atts)
      raise ArgumentError, "Login name cannot be empty!" if u.nil?
      u
    rescue Ohm::UniqueIndexViolation
      raise ArgumentError, "Your login name #{atts[:login_name]} already exists!"
    end
  end

  def update_with_check(atts)
    atts[:avatar] = User.normalize_avatar_url(atts[:avatar])
    begin
      u = update(atts)
      raise ArgumentError, "Arguments are not valid!" if u.nil?

      u.save
    rescue Ohm::UniqueIndexViolation
      raise ArgumentError, "Your login name #{atts[:login_name]} already exists!"
    end
  end
end
