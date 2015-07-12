$: << File.expand_path('../lib', File.dirname(__FILE__))
require 'config_file'

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

      db = URI.parse(ENV["DATABASE_URL"] || settings.db_connection_string)
      ActiveRecord::Base.establish_connection(
        :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host     => db.host,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8'
      )
      ActiveRecord::Base.logger = nil
    end
  end
  register Bootstrap
end

