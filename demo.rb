require_relative 'movie'
require_relative 'ancient_movie'
require_relative 'classic_movie'
require_relative 'modern_movie'
require_relative 'new_movie'
require_relative 'movie_collection'

require_relative 'netflix'
require_relative 'theatre'
require 'date'

file_name = ARGV[0] || "movies.txt"

if File.exist?(file_name)
  file = File.open(file_name)
else
  puts "Ошибка. Файл отсутствует!"
  exit
end

# создаем коллекцию фильмов из файла
movies = MovieCollection.new(file_name)

# выводим весь список файлов

#выдать фильтрованный список фильмов — по полям: года и страны
#movies.filter(genre: 'Comedy')
#movies.filter(year: 2000)
#movies.filter(year: 1980..2000)

#выдать сортированный список фильмов для любого поля
#movies.sort_by(:year)

#выводить статистику по запроcу: режиссер, актер, год, месяц, страна, жанр
#movies.stats(:author)

#выдать любое поле, в разумном формате
#movie = movies.all.first
#movie.actors.count
#movie.actors.include?('Arnold Shwarzenegger')

#ответить на запрос has_genre?('Comedy')
#movies.first.has_genre?('Camedy')

#онлайн кинотеатр
netflix1 = Netflix.new(file_name)
netflix2 = Netflix.new(file_name)
netflix3 = Netflix.new(file_name)
puts netflix1.pay(1)
puts netflix2.pay(10)
puts netflix3.pay(114)
puts Netflix.cash
#puts netflix.pay(25)
#puts netflix1.cash
#puts netflix2.cash
#puts netflix3.cash
#movie = netflix.filter(genre: 'Comedy').first
puts netflix1.film_costs(title: 'The Terminator')
#puts netflix.film_costs(title: 'The Terminator')
# netflix.pay(25)
# netflix.cash
# netflix.pay(25)
# netflix.cash

puts netflix1.show(genre: 'Comedy', period: :classic)

#movie.matches_all?( { genre: ['Comedy', 'Adventure'] } )
#netflix.pay(25)
#puts netflix.balance
#puts netflix.show(genre: 'Comedy', period: :modern)
# netflix.pay(0)
#netflix.pay(25)
#netflix1.show(title: 'The Terminator')
#puts netflix.balance

theatre = Theatre.new(file_name)

#theatre.cash
# theatre.buy_ticket(title: 'Vertigo')
# theatre.cash
# theatre.take('Bank')
# theatre.cash
# theatre.cash
# theatre.buy_ticket(title: 'The Maltese')
# theatre.cash

#movie = theatre.filter(genre: 'Comedy').first
#puts movie.match?(:genre, ['Comedy', 'Drama'])
#puts movie.match?(:year, 1993...1998)
#puts movie.matches_all?( {genre: ['Comedy', 'Drama'], year: 1993...1998} )
# puts theatre.cashbox_balance
# theatre.buy_ticket('13:20')
# puts theatre.cashbox_balance
#theatre.when?(title: 'Vertigo')
#puts theatre.filters_to_hash({ genre: ['Comedy', 'Adventure']})


