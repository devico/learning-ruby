require_relative 'lib/top_movies'
require 'date'

file_name = ARGV[0] || '../lib/topmovies/data/movies.txt'

if File.exist?(file_name)
  File.open(file_name)
else
  puts 'Ошибка. Файл отсутствует!'
  exit
end

movies = TopMovies::MovieCollection.new(file_name)
movie = movies.all[112]
puts movie.budget
puts movie.poster
