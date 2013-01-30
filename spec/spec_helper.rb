ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.setup

require 'rack/test'
require 'rspec'
require_relative '../app.rb'
