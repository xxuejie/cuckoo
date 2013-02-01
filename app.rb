#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'rack/protection'

# Use RedisToGo on Heroku
ENV['REDIS_URL'] = ENV['REDISTOGO_URL'] || ENV['REDIS_URL'] || 'redis://localhost:6379'

use Rack::Protection

LIB_PATH = File.join(File.dirname(__FILE__), "lib")
$LOAD_PATH.unshift(LIB_PATH)

Dir["#{LIB_PATH}/helpers/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/models/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/routes/*.rb"].each {|f| require f}

enable :sessions
set :session_secret, ENV['SESSION_KEY'] || "Thisisaverylongsessionsecretfortesting"

include Helpers::Login

use CuckooServer
use CuckooApi
