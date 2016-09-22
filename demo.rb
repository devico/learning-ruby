require_relative 'movie'
require_relative 'ancient_movie'
require_relative 'classic_movie'
require_relative 'modern_movie'
require_relative 'new_movie'
require_relative 'movie_collection'
require_relative 'filter_genre'
require_relative 'country_filter'
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
# puts movies.class
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
# puts online.by_genre.comedy
puts online.by_country.usa
# puts TopMovies::Movie.respond_to?(:uk)
# online.respond_to?(uk)
# puts online.by_country.class.methods
# puts online.methods
# puts online.by_genre.comedy
# puts online.drama
# puts online.by_genre
# puts movies.class
# movie = online.filter(period: :new).first
# movie = online.filter(genre: 'Comedy', period: :classic).first
# puts movie.matches_all?( {genre: ['Comedy, Drama'], year: 1993...1998} )
# puts movie.genre.inspect
# puts !movie.title.include?('Terminator')
# p movie.genre
# puts movie.year > 2003
# puts movie.year.class
# puts online.pay(25)
# online2 = TopMovies::Netflix.new(file_name)
# online3 = TopMovies::Netflix.new(file_name)
# puts online1.pay(1)
# puts online2.pay(10)
# puts online3.pay(114)
# puts TopMovies::Netflix.cash
# online.pay(40)
# puts online.cash
# puts online.cash
# puts online.show(genre: 'Drama', period: :new)
# movies = online.show do |movie|
#   !movie.title.include?('Terminator') && \
#     movie.genre[0].include?('Action') && \
#     movie.year > 2003
# end
# puts movies
# online.define_filter(:new_sci_fi) do |movie|
#   movie.genre[0].include?('Sci-Fi') && \
#     !movie.country.include?('UK')
# end
# puts online.show(new_sci_fi: true)
# online.define_filter(:not_spielberg) do |movie|
#   !movie.author.include?('Steven Spielberg')
# end
# puts online.show(new_sci_fi: true, not_spielberg: true)
# online.define_filter(:new_sci_fi) { |movie, year| movie.year > year }
# puts online.show(new_sci_fi: 2010)
# online.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014).class
# puts online.show(newest_sci_fi: 2014)
# puts online.show(title: 'The Tirminator')
# puts online.show(new_sci_fi: true)
# online.define_filter(:country) do |movie|
#    movie.genre.include?('Sci-Fi') && \
#      !movie.author.include?('Steven Spielberg') && \
#      !movie.country.include?('UK')
# end
# puts online.show(title: 'The Terminator')
# puts online.show(new_sci_fi: true)
# puts online2.cash
# puts online3.cash
# movie = online.filter(genre: 'Comedy').first
# puts online1.film_costs(title: 'The Terminator')
# puts online.film_costs(title: 'The Terminator')
# online.pay(25)
# online.cash
# online.pay(25)
# online.cash
# puts online1.show(genr/e: 'Comedy', period: :classic)
# movie.matches_all?(genre: %w(Comedy Adventure))
# online.pay(25)
# puts online.balance
# puts online.show(genre: 'Comedy', period: :modern)
# puts online.cash
#  online.pay(0)
# online.pay(25)
# online1.show(title: 'The Terminator')
# puts online.balance
# theatre = TopMovies::Theatre.new
theatre =
  TopMovies::Theatre.new do
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12

    period '09:00'..'12:00' do
      description 'Утренний сеанс'
      filters genre: 'Comedy', year: 1900..1980
      price 10
      hall :red, :blue
    end

    period '12:00'..'16:00' do
      description 'Спецпоказ'
      title 'The Terminator'
      price 50
      hall :green
    end

    period '16:00'..'20:00' do
      description 'Вечерний сеанс'
      filters genre: %w(Action Drama), year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end

    period '19:00'..'22:00' do
      description 'Вечерний сеанс для киноманов'
      filters year: 1900..1945, exclude_country: 'USA'
      price 30
      hall :green
    end
  end

theatre.period '21:00'..'23:00' do
  description 'Еще один сеанс'
  filters genre: 'Sci-Fi', year: 1900..1980
  price 13
  hall :red
end

# puts theatre.accept_description
# movie = theatre.filter(title: "The Terminator").first
# puts theatre.time_to_show('15:20')
# puts theatre.show(period).genre
# puts movie.title
# puts theatre
puts theatre.buy_ticket('10:20')
puts theatre.buy_ticket('13:20')
puts theatre.buy_ticket('17:20')
puts theatre.buy_ticket('19:20', hall: :green)
# puts theatre.cash
# theatre.take('Bank')
# theatre.cash
# theatre.cash
# theatre.buy_ticket(title: 'The Maltese')
# theatre.cash
# puts movie.match?(:genre, ['Comedy', 'Drama'])
# puts movie.match?(:year, 1993...1998)
# puts theatre.cashbox_balance
# theatre.buy_ticket('13:20')
# puts theatre.cashbox_balance
# puts theatre.when?(title: 'Vertigo')
# puts theatre.filters_to_hash({ genre: ['Comedy', 'Adventure']})
