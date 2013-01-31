require 'spec_helper'

describe 'Tweet model' do
  before(:each) do
    Ohm.flush
    @u = User.create({login_name: "new_user",
                       hashed_password: "pass",
                       salt: "salt"})
  end

  it "should be able to create a new tweet" do
    tweet = Tweet.create({user: @u,
                           content: "tweet content",
                           time: "1359590189979"})
    expect(tweet).to_not be_nil
    expect(tweet.user.id).to eq(@u.id)
    expect(tweet.content).to eq("tweet content")
    expect(tweet.time).to eq("1359590189979")
  end

  it "should not be able to create tweet without user" do
    expect(Tweet.create({content: "content", time: "1"})).to be_nil
  end

  it "should not be able to create tweet without content" do
    expect(Tweet.create({user: @u, time: "1"})).to be_nil
  end

  it "should not be able to create tweet without time" do
    expect(Tweet.create({user: @u, content: "content"})).to be_nil
  end
end
