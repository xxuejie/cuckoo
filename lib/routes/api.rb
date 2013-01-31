require 'sinatra/base'
require 'json'

require 'pry'

class CuckooApi < Sinatra::Base
  include Helpers::ApiHelpers

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

  get '/api/tweets.json' do
    check_api_login!

    u = session[:user]
    result = []

    Helpers::add_tweets_to_result(u, result)
    u.followers.each do |follower|
      Helpers::add_tweets_to_result(follower, result)
    end

    result.to_json
  end

  post '/api/tweets.json' do
    check_api_login!

    user = session[:user]
    content = json_request['content']

    if content
      tweet = Tweet.create({content: content,
                             # Time is in milliseconds
                             time: Time.now.to_i * 1000,
                             user: user})
      Helpers::result_ok({content: tweet.content,
                           time: tweet.time,
                           user_id: user.id,
                           user_name: user.login_name})
    else
      Helpers::result_error("Content is required!")
    end
  end
end
