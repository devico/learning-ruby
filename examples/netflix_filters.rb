require_relative '../lib/top_movies'
require 'date'

file_name = ARGV[0] || '../lib/topmovies/data/movies.txt'

if File.exist?(file_name)
  File.open(file_name)
else
  puts 'Ошибка. Файл отсутствует!'
  exit
end

online = TopMovies::Netflix.new(file_name)
online.pay(35)

# inner filters
puts online.show(genre: 'Drama', period: :new)

# component filter
movies = online.show do |movie|
  !movie.title.include?('Terminator') && \
    movie.genre[0].include?('Action') && \
    movie.year > 2003
end
puts movies

# define new filter
online.define_filter(:new_sci_fi) do |movie|
  movie.genre[0].include?('Sci-Fi') && \
    !movie.country.include?('UK')
end
puts online.show(new_sci_fi: true)

online.define_filter(:not_spielberg) do |movie|
  !movie.author.include?('Steven Spielberg')
end
puts online.show(new_sci_fi: true, not_spielberg: true)

online.define_filter(:country) do |movie|
  movie.genre.include?('Sci-Fi') && \
    !movie.author.include?('Steven Spielberg') && \
    !movie.country.include?('UK')
end

# define new filter based on existing filter
online.define_filter(:new_sci_fi) { |movie, year| movie.year > year }
puts online.show(new_sci_fi: 2010)
online.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)
puts online.show(newest_sci_fi: 2014)
