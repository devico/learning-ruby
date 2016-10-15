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

# collection filters by genre
puts movies.filter(genre: 'Comedy')

# collection filters by year
movies.filter(year: 2000)
movies.filter(year: 1980..2000)

# collection sorts by year
movies.sort_by(:year)

# collection statistics by author
puts movies.stats(:author)

# collection have or not have
movie = movies.all.first
puts movie.actors.count
puts movie.actors.include?('Arnold Shwarzenegger')
