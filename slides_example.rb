require 'sinatra'
require 'sinatra/reloader'

set :port, 3003
set :bind, '0.0.0.0'

visits ||= 0

get '/' do
  visits += 1

  if visits >= 5
    redirect('/say-my-name')
  end

  "Hi there! You have visited this page #{visits} times."
end

get '/say-my-name' do
  'Walter'
end

post '/unvisit' do
  visits -= 1 if visits > 0
  true
end
