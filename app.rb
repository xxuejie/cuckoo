#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

get '/' do
  redirect to('/index.html#/home')
end

get '/me' do
  redirect to('/index.html#/me')
end

get '/users' do
  redirect to('/index.html#/users')
end

get '/user/:id' do
  redirect to("/index.html#/user/#{params[:id]}")
end
