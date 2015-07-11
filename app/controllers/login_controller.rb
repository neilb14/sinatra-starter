get '/login' do
	haml :login
end

post '/login' do
	redirect to('/')
end