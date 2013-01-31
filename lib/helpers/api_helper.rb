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
      JSON.parse(request.body.read)
    end
  end
end
