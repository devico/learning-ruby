require_relative 'movie_collection'

class Movie
  attr_accessor :link, :title, :year, :country, :date, :genre, :length, :rate, :author, :actors, :period

  def initialize(link, title, year, country, date, genre, length, rate, author, actors, movie_collection)
    @link = link
    @title = title
    @year = year.to_i
    @country = country
    @date = date
    @genre = genre.split(',')
    @length = length
    @rate  = rate
    @author = author
    @actors = actors.split(',')
    @collection = movie_collection
  end

  def match?(filter_name, filter_value)
    value = send(filter_name)
    if value.kind_of? Array
      value.include?(filter_value)
    else
      filter_value === value
    end
  end

  def has_genre?(type_of_genre)
    raise ArgumentError, "Жанра #{type_of_genre} в коллекции нет!" unless @collection.genre_exists?(type_of_genre)
    @genre.include?(type_of_genre)
  end

  def afisha

    time_now = Time.now
    case @year
      when 1900...1945 then "#{@title} — старый фильм (#{@year} год)"
      when 1945...1968 then "#{@title} — классический фильм, режиссёр #{@author}"
      when 1968...2000 then "#{@title} — современное кино: играют #{@actors.join(", ")}"
      when 2000..2015 then "#{@title} — новинка, вышло #{time_now.year - @year} лет назад!"
      else
    end

  end


end