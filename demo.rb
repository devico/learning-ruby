require_relative 'movie'
require_relative 'ancient_movie'
require_relative 'classic_movie'
require_relative 'modern_movie'
require_relative 'new_movie'
require_relative 'movie_collection'

require_relative 'netflix'
require_relative 'theatre'
require 'date'

file_name = ARGV[0] || 'movies.txt'

if File.exist?(file_name)
  File.open(file_name)
else
  puts 'Ошибка. Файл отсутствует!'
  exit
end

# movies = TopMovies::MovieCollection.new(file_name)

# movies.filter(genre: 'Comedy')
# movies.filter(year: 2000)
# movies.filter(year: 1980..2000)

# movies.sort_by(:year)

# movies.stats(:author)

# movie = movies.all.first
# movie.actors.count
# movie.actors.include?('Arnold Shwarzenegger')

# movies.first.has_genre?('Camedy')

online = TopMovies::Netflix.new(file_name)
# puts online
# movie = online.filter(period: :classic).first
# puts online.pay(25)
#  online2 = TopMovies::Netflix.new(file_name)
#  online3 = TopMovies::Netflix.new(file_name)
#  puts online1.pay(1)
#  puts online2.pay(10)
#  puts online3.pay(114)
#  puts TopMovies::Netflix.cash
online.pay(32)
puts online.cash
# puts online2.cash
# puts online3.cash
# movie = online.filter(genre: 'Comedy').first
# puts online1.film_costs(title: 'The Terminator')
# puts online.film_costs(title: 'The Terminator')
#  online.pay(25)
#  online.cash
#  online.pay(25)
#  online.cash
# puts online1.show(genre: 'Comedy', period: :classic)
# movie.matches_all?(genre: %w(Comedy Adventure))
# online.pay(25)
# puts online.balance
online.show(genre: 'Comedy', period: :modern)
online.cash
#  online.pay(0)
# online.pay(25)
# online1.show(title: 'The Terminator')
# puts online.balance

# theatre = TopMovies::Theatre.new(file_name)
# movie = theatre.filter(genre: 'Comedy').first
# theatre.show('15:20')
# puts movie
# theatre.cash
#  theatre.buy_ticket(title: 'Vertigo')
#  theatre.cash
#  theatre.take('Bank')
#  theatre.cash
#  theatre.cash
#  theatre.buy_ticket(title: 'The Maltese')
#  theatre.cash
# puts movie.match?(:genre, ['Comedy', 'Drama'])
# puts movie.match?(:year, 1993...1998)
# puts movie.matches_all?( {genre: ['Comedy', 'Drama'], year: 1993...1998} )
#  puts theatre.cashbox_balance
#  theatre.buy_ticket('13:20')
#  puts theatre.cashbox_balance
# theatre.when?(title: 'Vertigo')
# puts theatre.filters_to_hash({ genre: ['Comedy', 'Adventure']})
