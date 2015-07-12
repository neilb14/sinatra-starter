require 'uri'
require 'sinatra/activerecord/rake'

def read_config_value(environment, key)
	if @settings.nil?
		file = File.join(File.expand_path('../config', __FILE__), @environment.to_s + ".config")
		@settings = YAML.load(IO.read(file))		
	end
	@settings[key]
end

@environment = ENV['RACK_ENV'].nil? ? :development : ENV['RACK_ENV'].intern
db = URI.parse(ENV["DATABASE_URL"] || read_config_value(@environment, 'db_connection_string'))
ActiveRecord::Base.establish_connection(
	:adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
	:host     => db.host,
	:username => db.user,
	:password => db.password,
	:database => db.path[1..-1],
	:encoding => 'utf8'
)
