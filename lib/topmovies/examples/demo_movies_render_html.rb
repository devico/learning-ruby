require_relative '../movie'
require_relative '../ancient_movie'
require_relative '../classic_movie'
require_relative '../modern_movie'
require_relative '../new_movie'
require_relative '../movie_collection'
require_relative '../filter_genre'
require_relative '../country_filter'
require_relative '../netflix'
require_relative '../theatre'
require 'date'

file_name = ARGV[0] || '../data/movies.txt'

if File.exist?(file_name)
  File.open(file_name)
else
  puts 'Ошибка. Файл отсутствует!'
  exit
end

movies = TopMovies::MovieCollection.new(file_name)
movies.render_html
