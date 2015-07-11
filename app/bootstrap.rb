$: << File.expand_path('../lib', File.dirname(__FILE__))
require 'sinatra/base'
require 'config_file'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-chunked_query'
require 'dm-aggregates'

module Sinatra
  module Bootstrap
    DEFAULT_DEPENDENCIES = [:yaml, :haml, :json, :uuidtools]

    def load_dependencies(*args)
      (args + DEFAULT_DEPENDENCIES).uniq.each do |lib|
        begin
          require lib.to_s
        rescue LoadError
          puts "== Unable to load dependency - #{lib}"
          exit 0
        end
      end
    end		

    def start_app!(parameters = {})      
      config_file File.expand_path('../../config/', __FILE__)
      required_dependencies = parameters[:libs] ||= []
      load_dependencies *(required_dependencies)
      set :views, 'app/views'
      enable :sessions, :logging, :dump_errors, :raise_errors
      set :session_secret, "I<3Dogs"
      set :protection, except: :session_hijacking      
      
      #the order of files loaded matters. unfortunately the order is unpredicible on Heroku so must sort...
      Dir.glob("lib/**/*.rb").sort.each { |f| load f }        
      Dir.glob("app/models/**/*.rb") { |f| load f}
      Dir.glob("app/controllers/**/*.rb") { |f| load f}
      DataMapper.setup(:default, ENV["DATABASE_URL"] || settings.db_connection_string)
      configure :development do
        DataMapper.auto_upgrade!
      end
      DataMapper.finalize
    end
  end
  register Bootstrap
end

