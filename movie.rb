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

  def match?(filter_name, filter_value)
    filter = send(filter_name)
    if filter.kind_of? Array
      filter.include?(filter_value)
    else
      filter === filter_value
    end
  end

  def has_genre?(type_of_genre)
    raise ArgumentError, "Жанра #{type_of_genre} в коллекции нет!" unless @collection.genre_exists?(type_of_genre)
    @genre.include?(type_of_genre)
  end
end