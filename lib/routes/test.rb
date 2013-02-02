require 'sinatra/base'

class CuckooTest < Sinatra::Base
  include Helpers::Api

  # Reset the database to pre-defined data. This is used by the end-to-end
  # test in Angular
  get '/reset' do
    Ohm.flush

    u1 = User.create_with_check({login_name: "user1",
                                  password: "pass1",
                                  avatar: "user1@example.com",
                                  description: "I'm the first user"})
    u2 = User.create_with_check({login_name: "user2",
                                  password: "pass2",
                                  avatar: "user2@example.com",
                                  description: "I'm the second user"})
    Tweet.create({content: "This a tweet by user1!",
                   time: get_current_time,
                   user: u1})
    Tweet.create({content: "This another tweet by user1!",
                   time: get_current_time,
                   user: u1})
    Tweet.create({content: "user2 posted this!",
                   time: get_current_time,
                   user: u2})
    Tweet.create({content: "someone also posted this!",
                   time: get_current_time,
                   user: u2})
  end
end
