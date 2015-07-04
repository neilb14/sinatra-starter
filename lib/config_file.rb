require 'sinatra/base'
require 'yaml'

module Sinatra
	module ConfigFile	
		def config_file(path)			
			file = File.join(path, environment.to_s + ".config")
			return unless File.exists?(file)
			$stderr.puts "== loading config file '#{file}'" if logging?
			document = IO.read(file)
			YAML.load(document).each_pair do |key,value|
				set key, value
			end
		end
	end
	register ConfigFile
	Delegator.delegate :config_file
end