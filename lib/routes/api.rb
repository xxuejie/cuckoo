require 'sinatra/base'
require 'json'

class CuckooApi < Sinatra::Base
  get '/api/me.json' do
    check_api_login!

    u = session[:user]
    {
      id: u.id,
      login_name: u.login_name,
      avatar: u.avatar,
      description: u.description,
      tweet_count: u.tweets.size,
      followers: u.followers.size,
      following: u.following.size
    }.to_json
  end
end
