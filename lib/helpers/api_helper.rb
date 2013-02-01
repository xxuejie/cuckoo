require 'json'

module Helpers
  module Api
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

    def result_ok(data)
      {status: "ok", data: data}.to_json
    end

    def result_error(error)
      {status: "error", error: error}.to_json
    end

    def json_request!
      request.body.rewind
      JSON.parse(request.body.read, symbolize_names: true)
    end

    def get_json_user_hash(u)
      {
        id: u.id,
        login_name: u.login_name,
        avatar: u.avatar,
        description: u.description,
        tweet_count: u.tweets.size,
        followers: u.followers.size,
        following: u.following.size
      }
    end
  end
end
