require_relative '../lib/top_movies'

file_name = ARGV[0] || '../lib/topmovies/data/movies.txt'

if File.exist?(file_name)
  File.open(file_name)
else
  puts 'Ошибка. Файл отсутствует!'
  exit
end

online = TopMovies::Netflix.new(file_name)
puts online.by_genre.comedy
puts online.by_country.usa
