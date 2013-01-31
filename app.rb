#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'rack/protection'

use Rack::Protection

LIB_PATH = File.join(File.dirname(__FILE__), "lib")
$LOAD_PATH.unshift(LIB_PATH)

Dir["#{LIB_PATH}/helpers/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/models/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/routes/*.rb"].each {|f| require f}

enable :sessions

include Helpers::LoginHelpers

get '/' do
  check_login!
  redirect to('/index.html#/home')
end

get '/me' do
  check_login!
  redirect to('/index.html#/me')
end

get '/users' do
  check_login!
  redirect to('/index.html#/users')
end

get '/user/:id' do
  check_login!
  redirect to("/index.html#/user/#{params[:id]}")
end

post '/api/signin' do
  u = User.authenticate(params[:login_name], params[:password])
  if u
    session[:user] = u
    redirect to('/')
  else
    redirect to("/signin.html?error=#{Helpers::encode_uri("Login name or password is incorrect!")}")
  end
end

post '/api/me' do
  begin
    u = User.create_with_check({login_name: params[:login_name],
                                 password: params[:password],
                                 avatar: params[:avatar],
                                 description: params[:description]})
    session[:user] = u
    redirect to ('/')
  rescue ArgumentError => e
    redirect to("/signup.html?error=#{Helpers::encode_uri(e.message)}")
  end
end
