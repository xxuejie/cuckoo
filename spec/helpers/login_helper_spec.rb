require 'spec_helper'

describe "login helper" do
  include Helpers::Login

  before(:each) do
    @session = {}
    should_receive(:session).at_least(:once) { @session }
  end

  it "should redirect without session" do
    mock_object = "mock_object"
    should_receive(:to).with('/signin.html') { mock_object }
    should_receive(:redirect).with(mock_object)

    check_login!
  end

  it "should halt with 403 when calling api without session" do
    should_receive(:halt).with(403)

    check_api_login!
  end

  describe "calling with session" do
    before(:each) do
      @user = "mock_user_object"
      User.should_receive(:[]).with(1) {@user}

      @session[:user] = 1
    end

    it "should work for check_api_login!" do
      expect(check_api_login!).to eq(@user)
    end

    it "should work for check_login!" do
      expect(check_login!).to equal(@user)
    end
  end

  it "should set session" do
    user = double("User", id: 1)
    set_session_user!(user)

    expect(@session[:user]).to be(1)
  end

  it "should delete session" do
    @session[:user] = 1
    set_session_user!(nil)

    expect(@session[:user]).to be_nil
  end
end
