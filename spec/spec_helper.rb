ENV['RACK_ENV'] = 'test'
# Use a different database for tests
ENV['REDIS_URL'] ||= "redis://localhost:17890/11"

require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'rack/test'
require 'rspec'
require_relative '../app.rb'

# Save the trouble to require this in each file
require 'pry'

# sinatra test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
