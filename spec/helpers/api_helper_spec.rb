require 'spec_helper'

describe 'api helper' do
  include Helpers::Api

  it "should add new tweet to the result list" do
    t1 = double("Tweet", content: "thisisatweet", time: "1359745635054")
    t2 = double("Tweet", content: "anothertweet", time: "1359745635053")

    u = double("User", id: 1, login_name: "auser",
               tweets: [t1, t2])

    expected_result = [{content: t1.content,
                         time: t1.time,
                         user_id: u.id,
                         user_name: u.login_name},
                       {content: t2.content,
                         time: t2.time,
                         user_id: u.id,
                         user_name: u.login_name}]
    actual_result = []

    add_tweets_to_result(u, actual_result)
    expect(actual_result).to eq(expected_result)
  end

  it "should create success json result" do
    data = {tag: "This is the data field"}
    result = "{\"status\":\"ok\",\"data\":{\"tag\":\"This is the data field\"}}"

    expect(result_ok(data)).to eq(result)
  end

  it "should create error json result" do
    error_str = "An error occurs"
    result = "{\"status\":\"error\",\"error\":\"An error occurs\"}"

    expect(result_error(error_str)).to eq(result)
  end

  it "should parse json request" do
    body = double()
    body.should_receive(:rewind)
    body.should_receive(:read) { "{\"aaa\": \"bbb\"}" }

    request = double()
    request.should_receive(:body).twice { body }

    should_receive(:request).twice { request }

    result = {aaa: "bbb"}

    expect(json_request!).to eq(result)
  end

  it "should create json hash based on object" do
    result = {
      id: 1,
      login_name: "auser",
      avatar: "thisisaavatar",
      description: "thisisdescription",
    }

    user = double("User")
    result.each do |k, v|
      user.stub(k => v)
    end

    result[:tweet_count] = 100
    result[:followers] = 123
    result[:following] = 235

    user.stub_chain(:tweets, :size => result[:tweet_count])
    user.stub_chain(:followers, :size => result[:followers])
    user.stub_chain(:following, :size => result[:following])

    expect(get_json_user_hash(user)).to eq(result)
  end
end
