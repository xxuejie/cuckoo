require 'rack/protection'
require './app'

# TODO: add secret here!!!!
use Rack::Session::Pool
use Rack::Protection

run Sinatra::Application
