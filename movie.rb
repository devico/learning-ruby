require_relative 'movie_collection'

class Movie
  attr_accessor :link, :title, :year, :country, :date, :genre, :length, :rate, :author, :actors

  def initialize(link, title, year, country, date, genre, length, rate, author, actors)
    @link = link
    @title = title
    @year = year
    @country = country
    @date = date
    @genre = genre.split(',')
    @length = length
    @rate  = rate
    @author = author
    @actors = actors.split(',')
  end

  def actors
   @actors
  end

  def has_genre?(type_of_genre)
    #проверяем жанр в коллекции
#    if movies.genre_films == false
#      raise  'Такого жанра в природе не существует!'
#    else
#      @genre.include?(type_of_genre)
#    end
  end
end