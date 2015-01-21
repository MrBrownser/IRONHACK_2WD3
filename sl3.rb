require 'imdb'
require 'pry'

# SL3. More TDD (I mean, TV) series!

# Tired of the discussion between Sopranos vs The Wire? Hint: watch True Detective, House of Cards or Breaking Bad, and we’ll talk later.
# Are you tired of watching Friends for the 254th time? Well, I wouldn’t recommend How I Met Your Mother too much but… how about tech? Check
# out Halt & Catch Fire (AMC) or Silicon Valley (HBO)! Anyway, wake up, we are tired and it’s Monday, but you don’t want to look like
# someone from The Walking Dead, right?

# Let’s enlarge SL2 but with a change. Until now, we used our beliefs for the returning values of the methods. This time, though, we will
# use real information from one site called IMDB, which turns out to have a nice and fun API. And this time, instead of writing the
# tests afterwards, we will write them first hand. Let’s go do some nice TDD!

# The first method will take a string as a parameter (for example, ‘Cat’) and return the number of results for that search in IMDB. For
# ‘Cat’, it’s more than 200 examples! That’s a lot of cats indeed!

# The second method will be similar to “best_within”… but instead of returning the best one based on the rating, it will return the one
# with most seasons! We will call this method “most_seasons_from”. Example: we call the method with the following TV series: Breaking Bad
# (5 seasons), Friends (10 seasons), Game of Thrones (6 seasons: they renewed for two more!) and The Office (9 seasons). It should return Friends!
# And this way we'll be able to know which show will make us more socially missing, too.

# The third method will be similar to "most_seasons_from", but instead of having the season into account, it will have the number of episodes
# into account.

# The four method will be a comparator (it might turn into our best friend!). It will take an array of strings, each one being
# the name of a TV show, and it will return the best one using IMDB ratings. For example, if we pass Breaking Bad, Pacific Blue (oh, those
# times!) and The Affair, it will return Breaking Bad (although The Affair is really good, and just won a Golden Globe, even when Golden Globes
# are worthless).

# The fifth and final method will get an integer argument, let's call it X, and will return a hash with the top X movies following IMDB
# rating, including it too. The integer argument should be between 1 and 250, and the returned hash should look like:
# {
#   'Shawsank Redemption' => 9.2,
#   'The Godfather' => 9.2,
#   'The Godfather II' => 9.0,
#   'The Dark Knight' => 8.9,
#   ...and so on until having X movies
# }

# ============================================================
# AND REMEMBER, WE WANT TDD. TESTS FIRST, THEN IMPLEMENTATION.
# ============================================================

# Note: if you grab results from Imdb::Search, it will always return a Imdb::Movie object, not Imdb::Serie. In order to get info an Imdb::Serie,
# which has information like the number of episodes, just use the id to fetch the serie directly:
#   dexter_movie = Imdb::Search.new(‘Dexter’).movies.first
#   dexter_serie = Imdb::Serie.new(dexter_movie.id)

class CompleteIMDBSearcher
	def count_imdb_results(keyword)
		Imdb::Search.new(keyword).movies.count
	end

	def most_seasons_from(series_arr)
		series = []

		series_arr.each do |serie|
			# binding.pry
			# tv_show = get_show_info(show)
			# @series << {show: tv_show.title, rating: tv_show.rating}
			temp_info = get_show_info(get_show_id(serie))
			series << { show: temp_info.title, seasons: temp_info.seasons.count }
			# series[temp_info.title.to_sym] = temp_info.seasons.count
		end
		series.sort_by! { |show| show[:seasons] }.last[:show].gsub("\"", "")
	end

	def most_episodes_from(series_arr)
		series = []
		series_arr.each do |serie|
			temp_info = get_show_info(get_show_id(serie))
			episodes = 0
			temp_info.seasons.each {|season| episodes += season.episodes.count}
			series << {show: temp_info.title, episodes: episodes}
		end
		series.sort_by! {|show| show[:episodes]}.last[:show].gsub("\"", "")
	end

	def serious_series_comparator(series_arr) # aka best_show_ever
		@series = []
		series_arr.each do |serie|
			tv_show = get_show_info(get_show_id(serie))
			@series << {show: tv_show.title, rating: tv_show.rating}
		end

		@series.sort_by! {|show| show[:rating]}.last[:show].gsub("\"", "")
	end

	def top_x_movies(number)
		top = Imdb::Top250.new
		top = top.movies.take(number.to_i)
		top_limit = []
		top.each {|movie| top_limit << movie.title.split.drop(1).join(' ')}
		top_limit
	end

	def get_show_info(show_id)
		name = Imdb::Serie.new(show_id)
	end

	def get_show_id(show_name)
		id = Imdb::Search.new(show_name).movies.first.id
	end
end

# TESTING IMPLEMENTATION

# describe CompleteIMDBSearcher do
# 	before do
# 		@searcher = CompleteIMDBSearcher.new
# 		# @testing_shows_arr = ["Friends"]
# 		@testing_shows_arr = ["Breaking Bad", "Friends", "Game of Thrones", "The Office"]
# 	end

# 	describe "#count_imdb_results" do
# 		it "returns more than 100 results from a 'cat' query" do
# 			count = @searcher.count_imdb_results("Cat")
# 			expect(count).to be > 100
# 		end
# 	end

# 	describe "#most_seasons_from" do
# 		it "returns the series with most seasons from a given array" do
# 			most_seasons_serie = @searcher.most_seasons_from(@testing_shows_arr)
# 			expect(most_seasons_serie).to eq("Friends")
# 		end
# 	end

# 	describe "#most_episodes_from" do
# 		it "returns the show with most episodes" do
# 			most_episodes_from = @searcher.most_episodes_from(@testing_shows_arr)
# 			expect(most_episodes_from).to eq("Friends")
# 		end
# 	end

# 	describe "#serious_series_comparator" do
# 		it "Returns the show with the best ratings of an array of series (valuated on imbd)" do
# 			best_show = @searcher.serious_series_comparator(@testing_shows_arr)
# 			expect(best_show).to eq('Breaking Bad')
# 		end
# 	end

# 	describe "#top_x_movies" do
# 		it "Returns the return a hash with the top 1 movie following IMDB rating" do
# 			best_movie = @searcher.top_x_movies(1)
# 			movie = ["Cadena perpetua"]

# 			expect(best_movie).to eq(movie)
# 		end

# 		# Ask for 5
# 		it "Returns the return a hash with the top 5 movies following IMDB rating" do
# 			movie_rating_results = ["Cadena perpetua", "El padrino", "El padrino. Parte II", "El caballero oscuro", "Pulp Fiction"]
# 			best_movies = @searcher.top_x_movies(5)

# 			expect(best_movies).to eq(movie_rating_results)
# 		end

# 		# Ask for 10
# 		it "Returns the return a hash with the top 10 movies following IMDB rating" do
# 			movie_rating_results = ["Cadena perpetua", "El padrino", "El padrino. Parte II", "El caballero oscuro", "Pulp Fiction", "El bueno, el feo y el malo", "12 hombres sin piedad", "La lista de Schindler", "El señor de los anillos: El retorno del rey", "El club de la lucha"]
# 			best_movies = @searcher.top_x_movies(10)

# 			expect(best_movies).to eq(movie_rating_results)
# 		end
# 	end

# end