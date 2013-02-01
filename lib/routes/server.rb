require 'sinatra/base'

# Module for basic redirects. All authentication work is done at API level.
class CuckooServer < Sinatra::Base

  get '/' do
    redirect to('/index.html#/home')
  end

  get '/me' do
    redirect to('/index.html#/me')
  end

  get '/users' do
    redirect to('/index.html#/users')
  end

  get '/user/:name' do
    redirect to("/index.html#/user/#{params[:name]}")
  end
end
