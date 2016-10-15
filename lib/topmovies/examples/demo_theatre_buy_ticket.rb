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

    period '21:00'..'23:00' do
      description 'Еще один сеанс'
      filters genre: 'Sci-Fi', year: 1900..1980
      price 13
      hall :red
    end
  end

puts theatre.buy_ticket('10:20')
puts theatre.buy_ticket('13:20')
puts theatre.buy_ticket('17:20')
puts theatre.buy_ticket('19:20', hall: :green)
puts theatre.cash
theatre.take('Bank')
puts theatre.cash
