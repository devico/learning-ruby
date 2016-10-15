require_relative '../movie'
require_relative '../ancient_movie'
require_relative '../classic_movie'
require_relative '../modern_movie'
require_relative '../new_movie'
require_relative '../movie_collection'
require_relative '../filter_genre'
require_relative '../country_filter'
require_relative '../netflix'

file_name = ARGV[0] || '../data/movies.txt'

if File.exist?(file_name)
  File.open(file_name)
else
  puts 'Ошибка. Файл отсутствует!'
  exit
end

online = TopMovies::Netflix.new(file_name)
puts online.by_genre.comedy
puts online.by_country.usa
