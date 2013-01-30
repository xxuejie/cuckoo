require 'spec_helper'

require 'models/user'
require 'models/tweet'

describe "User model" do
  before(:each) do
    Ohm.flush
  end

  it "should be able to create a new one" do
    u = User.create({login_name: "new_user",
                description: "desc",
                avatar: "http://www.gravatar.com/avatar/55502F40DC8B7C769880B10874ABC9D0"})
    expect(u).to_not be_nil
    expect(u.login_name).to eq("new_user")
    expect(u.description).to eq("desc")
    expect(u.avatar).to eq("http://www.gravatar.com/avatar/55502F40DC8B7C769880B10874ABC9D0")
    expect(u.tweets).to_not be_nil
    expect(u.tweets.size).to be(0)
  end

  it "should at least have a login name" do
    expect(User.create).to be_nil
  end

  it "should not be able to create 2 users with same name" do
    User.create({login_name: "aname"})
    expect {
      User.create({login_name: "aname"})
    }.to raise_error(Ohm::UniqueIndexViolation)
  end
end
