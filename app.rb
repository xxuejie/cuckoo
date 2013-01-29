#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

get '/' do
  "This works!"
end

get '/api/:user.json' do
  "Hello, #{params[:user]}"
end
