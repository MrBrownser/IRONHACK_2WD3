# SL6. Spotinatra (partial solution)

require 'sinatra'

# some class to store songs

get '/' do
  # we'll use the class to store songs
end

post '/songs/new' do
  # params[:name] & params[:artist] are available
  # we'll save the song information
  # we'll redirect to / or /enough depending on the songs
end

get '/enough' do
  "LEAVE ME ALONE WITH THESE CRAPPY SONGS"
end

__END__

no:

curl -L -X POST
  --data "name=TheHandsomeFamily,artist=FarFromAnyRoad"
  localhost:3001/songs/new

yes:

curl -L
  --data "name=TheHandsomeFamily,artist=FarFromAnyRoad"
  localhost:3001/songs/new
