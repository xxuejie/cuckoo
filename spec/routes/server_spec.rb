require 'spec_helper'

describe "server" do
  it "should redirect /" do
    get '/'
    last_response.location.should match(/\/index\.html#\/home$/)
  end

  it "should redirect /me" do
    get '/me'
    last_response.location.should match(/\/index\.html#\/me$/)
  end

  it "should redirect /users" do
    get '/users'
    last_response.location.should match(/\/index\.html#\/users$/)
  end

  it "should redirect /user/:name" do
    get '/user/auser'
    last_response.location.should match(/\/index\.html#\/user\/auser$/)
  end

  it "should issue 404 for nonexisting page" do
    get '/non-existing-page'
    last_response.status.should be(404)
  end
end
