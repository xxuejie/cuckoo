require 'sinatra/base'
require 'json'

class CuckooApi < Sinatra::Base
  include Helpers::Api

  get '/api/me.json' do
    myself = check_api_login!

    get_json_user_hash(myself).to_json
  end

  # Update personal information
  post '/api/me.json' do
    myself = check_api_login!

    begin
      myself = myself.update_with_check(json_request!)
      set_session_user!(myself)

      result_ok(get_json_user_hash(myself))
    rescue ArgumentError => e
      result_error(e.message)
    end
  end

  get '/api/tweets.json' do
    u = check_api_login!

    result = []

    add_tweets_to_result(u, result)
    u.followers.each do |follower|
      add_tweets_to_result(follower, result)
    end

    result.to_json
  end

  # Post a new tweet
  post '/api/tweets.json' do
    user = check_api_login!

    content = json_request![:content]

    if content
      tweet = Tweet.create({content: content,
                             # Time is in milliseconds
                             time: "#{Time.now.to_i * 1000}",
                             user: user})
      result_ok({content: tweet.content,
                           time: tweet.time,
                           user_id: user.id,
                           user_name: user.login_name})
    else
      result_error("Content is required!")
    end
  end

  get '/api/users.json' do
    myself = check_api_login!

    result = []

    User.all.each do |u|
      result << {
        id: u.id,
        login_name: u.login_name,
        avatar: u.avatar,
        description: u.description,
        followed: myself.followers.member?(u),
        myself: u.id == myself.id
      }
    end

    result.to_json
  end

  get '/api/user/:name.json' do
    myself = check_api_login!

    u = User.find({login_name: params[:name]}).first
    if u
      tweets = []
      u.tweets.each do |tweet|
        tweets << {content: tweet.content, time: tweet.time}
      end
      result_ok({id: u.id,
                login_name: u.login_name,
                avatar: u.avatar,
                description: u.description,
                followed: myself.followers.member?(u),
                myself: u.id == myself.id,
                tweets: tweets})
    else
      result_error("User #{params[:name]} does not exist!}")
    end
  end

  post '/api/follow.json' do
    myself = check_api_login!

    request = json_request!

    follower_id = request[:id]
    should_follow = request[:follow]

    if follower_id.nil? || should_follow.nil?
      return result_error("Missing arguments!")
    end

    if follower_id == myself.id
      return result_error("You cannot follow yourself!")
    end

    follower = User[follower_id]
    if follower
      if should_follow
        myself.followers.add(follower)
      else
        myself.followers.delete(follower)
      end
      result_ok({followed: should_follow})
    else
      result_error("Cannot find user #{follower_id}!")
    end
  end
end
