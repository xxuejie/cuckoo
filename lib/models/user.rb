require 'digest/md5'
require 'ohm'

class User < Ohm::Model
  attribute :login_name
  unique :login_name

  attribute :description
  attribute :avatar

  set :followers, :User
  set :following, :User

  collection :tweets, :Tweet

  def validate
    assert_present :login_name
  end
end
