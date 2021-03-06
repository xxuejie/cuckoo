require 'sinatra/base'
require 'json'

class CuckooApi < Sinatra::Base
  include Helpers::Api
  include Helpers::Url

  get '/api/signout.json' do
    set_session_user! nil
    result_ok({})
  end

  post '/api/signin.json' do
    p = json_request!

    u = User.authenticate(p[:login_name], p[:password])
    if u
      set_session_user! u
      result_ok({})
    else
      result_error("Login name or password is incorrect!")
    end
  end

  post '/api/signup.json' do
    p = json_request!

    begin
      u = User.create_with_check({login_name: p[:login_name],
                                   password: p[:password],
                                   avatar: p[:avatar],
                                   description: p[:description]})
      set_session_user! u
      result_ok({})
    rescue ArgumentError => e
      result_error(e.message)
    end
  end

  get '/api/me.json' do
    myself = check_api_login!

    result_ok(get_json_user_hash(myself))
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

    result_ok(result)
  end

  # Post a new tweet
  post '/api/tweets.json' do
    user = check_api_login!

    content = json_request![:content]

    return result_error("Content is missing!") if content.nil?
    return result_error("Content can not exceed 140 characters!") if content.length > 140

    tweet = Tweet.create({content: content,
                           time: get_current_time,
                           user: user})
    result_ok({content: tweet.content,
                time: tweet.time,
                user_id: user.id,
                user_name: user.login_name})
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

    result_ok(result)
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
      result_error("User #{params[:name]} does not exist!")
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
        follower.following.add(myself)
      else
        myself.followers.delete(follower)
        follower.following.delete(myself)
      end
      result_ok({followed: should_follow})
    else
      result_error("Cannot find user #{follower_id}!")
    end
  end
end
