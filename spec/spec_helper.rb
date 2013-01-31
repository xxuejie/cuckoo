ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.setup

require 'rack/test'
require 'rspec'
require_relative '../app.rb'

LIB_PATH = File.expand_path(File.dirname(__FILE__)) + "/../lib"
Dir["#{LIB_PATH}/helpers/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/models/*.rb"].each {|f| require f}
Dir["#{LIB_PATH}/routes/*.rb"].each {|f| require f}
