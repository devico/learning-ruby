require 'date'

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

  def self.create(link, title, year, country, date, genre, length, rate, author, actors, movie_collection)
    period = year.to_i
    movie_type = case period
      when 1900...1945 then AncientMovie
      when 1945...1968 then ClassicMovie
      when 1968...2000 then ModernMovie
      when 2000..2015 then NewMovie
      else raise ArgumentError, "Фильм не относится ни к одному классу"
    end

    movie_type.new(link, title, year, country, date, genre, length, rate, author, actors, movie_collection)

  end

  def match?(filter_name, filter_value)
    value = send(filter_name)
    if value.kind_of? Array
      value.include?(filter_value)
    else
      filter_value === value
    end
  end

  def matches_all?(filters)
    filters.detect{ |k, v| match?(k, v) }
  end

  def has_genre?(type_of_genre)
    raise ArgumentError, "Жанра #{type_of_genre} в коллекции нет!" unless @collection.genre_exists?(type_of_genre)
    @genre.include?(type_of_genre)
  end

  def show
    start_time = Time.now
    end_time = start_time + @length.to_i*60
    "Now showing: #{@title} #{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")}"
  end

  def period
    self.class.to_s.chomp("Movie").downcase.to_sym
  end

end