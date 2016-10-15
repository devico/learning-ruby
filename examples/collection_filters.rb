require_relative '../lib/top_movies'
require 'date'

file_name = ARGV[0] || '../lib/topmovies/data/movies.txt'

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
