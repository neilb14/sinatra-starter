require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require './app/bootstrap'
require 'rack-methodoverride-with-params'
require 'rack-flash'
use Rack::MethodOverrideWithParams
use Rack::Flash, :sweep => true
start_app!
