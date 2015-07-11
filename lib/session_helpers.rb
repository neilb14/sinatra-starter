module Sinatra
	module SessionHelpers
		def username
			session["user"] ? session["user"][:username] : ""
		end

		def user_full_name
			session["user"] ? session["user"][:first_name] + " " + session["user"][:last_name] : ""
		end

		def user_id
			session["user"] ? session["user"][:id] : ""
		end

		def user_is_admin
			session["user"] and session["user"][:role] == "admin"
		end
	end
	helpers SessionHelpers
end