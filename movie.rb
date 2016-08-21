module TopMovies
  class Movie
    attr_accessor :link, :title, :year, :country, :date, :genre, :length, :rate,
                  :author, :actors, :period

    def initialize(link, title, year, country, date, genre, length, rate,
                   author, actors, movie_collection)
      @link = link
      @title = title
      @year = year.to_i
      @country = country
      @date = date
      @genre = genre.split(',')
      @length = length
      @rate = rate
      @author = author
      @actors = actors.split(',')
      @collection = movie_collection
    end

    def self.create(link, title, year, country, date, genre, length, rate,
                    author, actors, movie_collection)
      mov_type = case year.to_i
                 when 1900...1945 then AncientMovie
                 when 1945...1968 then ClassicMovie
                 when 1968...2000 then ModernMovie
                 when 2000..2015 then NewMovie
                 else raise ArgumentError, 'Фильма такого класса нет'
                 end
      mov_type.new(link, title, year, country, date, genre, length, rate,
                   author, actors, movie_collection)
    end

    def match?(filter_name, filter_value)
      value = if filter_value.is_a? Symbol
                send(filter_name).to_s[11..-1].to_sym
              else
                send(filter_name)
              end

      if value.is_a? Array
        value.any? { |v| filter_value.include?(v) }
      else
        filter_value === value
      end
    end

    def matches_all?(filters)
      filters.all? { |k, v| match?(k, v) }
    end

    def genre?(type_of_genre)
      raise ArgumentError, "Жанра #{type_of_genre} в коллекции нет!" unless
        @collection.genre_exists?(type_of_genre)
      @genre.include?(type_of_genre)
    end

    def show
      start_time = Time.now
      end_time = start_time + @length.to_i * 60
      "Now showing: #{@title} #{start_time.strftime('%H:%M')}
        - #{end_time.strftime('%H:%M')}"
    end

    def period
      self.class.to_s.chomp('Movie').downcase.to_sym
    end
  end
end
