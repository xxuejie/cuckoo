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

  def self.authenticate(login_name, password)
    u = User.find({login_name: login_name}).first
    return nil if u.nil?
    return u if Helpers::encrypt_password(password, u.salt) ==
      u.hashed_password
    nil
  end
end
