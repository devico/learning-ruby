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
netflix = Netflix.new(file_name)
# movie = netflix.filter(period: :ancient).first
#puts movie.period
# netflix.pay(25)
# puts netflix.balance
# puts netflix.show(genre: 'Comedy', period: :modern)
# netflix.pay(0)
# puts netflix.show(title: 'The Trminator')
theatre = Theatre.new(file_name)
#puts theatre.show('10:20')
theatre.when?(title: 'The Terminator')
