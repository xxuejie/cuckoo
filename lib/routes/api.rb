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

  def add_tweets_to_result(user, result)
    user.tweets.each do |tweet|
      result << {
        content: tweet.content,
        time: tweet.time,
        user_id: user.id,
        user_name: user.login_name
      }
    end
  end

  get '/api/statuses.json' do
    check_api_login!

    u = session[:user]
    result = []

    add_tweets_to_result(u, result)
    u.followers.each do |follower|
      add_tweets_to_result(follower, result)
    end

    result.to_json
  end
end
