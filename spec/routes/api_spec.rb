require 'spec_helper'

describe 'api' do

  def post_json(loc, hash)
    post loc, hash.to_json
  end

  def fetch_json
    last_response.should be_ok
    JSON.parse(last_response.body, symbolize_names: true)
  end

  def signin
    post_json '/api/signin.json', {login_name: @login_name, password: @pass}
  end

  def expect_not_signin
    last_response.status.should be(403)
  end

  def expect_json_ok
    expect(fetch_json[:status]).to eq("ok")
  end

  def expect_json_error
    expect(fetch_json[:status]).to eq("error")
  end

  before(:each) do
    Ohm.flush

    @login_name = "aname"
    @pass = "pass"
    @avatar = "avatarvalue"
    @description = "description value"
    @id = User.create_with_check({login_name: @login_name,
                                   password: @pass,
                                   avatar: @avatar,
                                   description: @description}).id

    @wrong_pass = "123"
    @not_exist_login_name = "wrongname"
  end

  it "should be able to sign in" do
    signin
    expect_json_ok
  end

  it "should not be able to sign in with wrong password" do
    post_json '/api/signin.json', {login_name: @login_name, password: @wrong_pass}
    expect_json_error
  end

  it "should be able to sign out" do
    # we use the /api/me.json API which requires sign in to show that we did sign out
    get '/api/me.json'
    expect_not_signin

    signin
    get '/api/me.json'
    expect_json_ok

    get '/api/signout.json'
    get '/api/me.json'
    expect_not_signin
  end

  it "should be able to sign up for new user" do
    post_json '/api/signup.json', {
      login_name: @not_exist_login_name,
      password: @wrong_pass}
    expect_json_ok

    expect(User.find({login_name: @not_exist_login_name}).size).to be(1)
  end

  it "should not be able to use the API without signing in" do
    get '/api/me.json'
    expect_not_signin
  end

  it "should return information of the user itself" do
    signin
    get '/api/me.json'

    resp = fetch_json
    expect(resp[:status]).to eq("ok")

    data = resp[:data]
    expect(data[:id]).to eq(@id)
    expect(data[:login_name]).to eq(@login_name)
    expect(data[:avatar]).to eq(@avatar)
    expect(data[:description]).to eq(@description)
  end

  it "should be able to update information" do
    new_description = "this is a new description"

    signin
    post_json '/api/me.json', {description: new_description}
    expect_json_ok

    u = User[@id]
    expect(u.description).to eq(new_description)
  end

  it "should be able to publish and read new tweets" do
    content = "This is a new tweet!"

    original_count = User[@id].tweets.size

    signin
    post_json '/api/tweets.json', {content: content}
    expect_json_ok

    expect(User[@id].tweets.size).to be(original_count + 1)

    get '/api/tweets.json'
    resp = fetch_json

    expect(resp[:status]).to eq("ok")
    found = false
    resp[:data].each do |t|
      found = true if content == t[:content]
    end
    expect(found).to be_true
  end

  it "should be able to get a list of users" do
    count = User.all.size

    signin
    get '/api/users.json'
    resp = fetch_json
    expect(resp[:status]).to eq("ok")

    expect(resp[:data].length).to be(count)
  end

  it "should be able to fetch a user's information" do
    signin
    get "/api/user/#{@login_name}.json"
    expect_json_ok
  end

  it "should get error when the user to fetch does not exist" do
    signin
    get "/api/user/#{@not_exist_login_name}.json"
    expect_json_error
  end

  describe "follow tests" do

    before(:each) do
      @new_user = User.create_with_check({login_name: @not_exist_login_name,
                                          password: @wrong_pass})
      @new_user_id = @new_user.id
      @myself = User[@id]
      @myself.followers.delete(@new_user)
      @new_user.following.delete(@myself)
    end

    it "should be able to follow a user" do
      signin
      post_json '/api/follow.json', {id: @new_user_id, follow: true}
      expect_json_ok

      @myself = User[@id]
      @new_user = User[@new_user_id]
      expect(@myself.followers.member?(@new_user)).to be_true
      expect(@new_user.following.member?(@myself)).to be_true
    end

    it "should be able to unfollow a user" do
      @myself.followers.add(@new_user)
      @new_user.following.add(@myself)

      signin
      post_json '/api/follow.json', {id: @new_user_id, follow: false}
      expect_json_ok

      @myself = User[@id]
      @new_user = User[@new_user_id]
      expect(@myself.followers.member?(@new_user)).to be_false
      expect(@new_user.following.member?(@myself)).to be_false
    end

    it "should not be able to follow himself/herself" do
      signin
      post_json '/api/follow.json', {id: @id, follow: true}
      expect_json_error
    end
  end
end
