 require_relative 'movie'
 require_relative 'movie_collection'
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
movies.send :filter, year: 2000

#выдать сортированный список фильмов для любого поля
movies.send :sort_by, :year

#выводить статистику по запроcу: режиссер, актер, год, месяц, страна, жанр
movies.stats(:author)

#выдать любое поле, в разумном формате
movie = movies.all.first
movie.actors.count
movie.actors.include?('Arnold Shwarzenegger')

#ответить на запрос has_genre?('Comedy')
movie.has_genre?('Drama')