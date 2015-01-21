require 'sinatra'
require 'sinatra/reloader'

set :port, 3124
set :bind, '0.0.0.0'

visits ||= 0
errands ||= []

get '/' do
  visits += 1
  @visits = visits
  @errands = errands
  erb :today
end

post '/save_errand' do
  errands << params[:name]
  redirect('/')
end

get '/hello/:name' do
  visits += 1
  @name = params[:name]
  erb :name
end
