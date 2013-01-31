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

use CuckooServer
use CuckooApi
