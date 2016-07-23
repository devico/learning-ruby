require_relative 'movie_collection'

class Movie
  attr_accessor :link, :title, :year, :country, :date, :genre, :length, :rate, :author, :actors

  def initialize(link, title, year, country, date, genre, length, rate, author, actors, movie_collection)
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
    @collection = movie_collection
  end

  def actors
   @actors
  end

  def has_genre?(type_of_genre)
    if @collection.genre_exists?(type_of_genre) == false
      raise "Жанра #{type_of_genre} в коллекции нет!"
    else
      @genre.include?(type_of_genre)
    end
  end
end