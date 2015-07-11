require 'sinatra/base'

module Sinatra
	module Security
		def deny_if_not_authenticated(regex)
			before {							
				return if not request.path =~ regex
				halt 403, 'Unauthorized' if session[:user].nil? or session[:token].nil?
				@user_session = UserSession.valid(session[:token], request.ip)
				@user = @user_session.user
				halt 403, 'Unauthorized' unless @user_session and @user.active
			}
		end

		def deny_if_not_admin(regex)
			before {							
				return if not request.path =~ regex
				halt 403, 'Unauthorized' if session[:user].nil? or session[:token].nil?
				@user_session = UserSession.valid(session[:token], request.ip)
				@user = @user_session.user
				halt 403, 'Unauthorized' unless @user_session and @user.active and @user.is_admin?
			}
		end

		def redirect_if_not_authenticated(regex, location)	
			before {							
				return if not request.path =~ regex
				redirect to(location) if session[:user].nil? or session[:token].nil?
				@user_session = UserSession.valid(session[:token], request.ip)
				redirect to(location) unless @user_session
				@user = @user_session.user
				redirect to("/user/inactive") unless @user.active
			}
		end
	end

	register Security
end
