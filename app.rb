#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'rack/protection'

# Use RedisToGo on Heroku
ENV['REDIS_URL'] = ENV['REDISTOGO_URL'] || ENV['REDIS_URL']

LIB_PATH = File.join(File.dirname(__FILE__), "lib")
$LOAD_PATH.unshift(LIB_PATH)

Dir["#{LIB_PATH}/helpers/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/models/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/routes/*.rb"].each {|f| require f}

enable :sessions
set :session_secret, ENV['SESSION_KEY'] || "Thisisaverylongsessionsecretfortesting"

include Helpers::Login

if ENV['E2E_TEST'] == 'true'
  # This server is launched for end-to-end test only
  ENV['REDIS_URL'] ||= "redis://localhost:17890/11"
  set :port, 17891
  File.open('./tmp/app.pid', 'w') do |f|
    f.write "#{Process.pid}\n"
  end
  use CuckooTest
else
  # Rake::Protection would result in failure for e2e test cases
  use Rack::Protection
end

use CuckooServer
use CuckooApi
