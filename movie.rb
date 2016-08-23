module TopMovies
  class Movie
    attr_accessor :link, :title, :year, :country, :date, :genre, :length, :rate,
                  :author, :actors, :period

    def initialize(params)
      @link = params[:link]
      @title = params[:title]
      @year = params[:year].to_i
      @country = params[:country]
      @date = params[:date]
      @genre = params[:genre].split(',')
      @length = params[:length]
      @rate = params[:rate]
      @author = params[:author]
      @actors = params[:actors].split(',')
      @collection = params[:collection]
    end

    def self.create(params)
      mov_type = case params[:year].to_i
                 when 1900...1945 then AncientMovie
                 when 1945...1968 then ClassicMovie
                 when 1968...2000 then ModernMovie
                 when 2000..2015 then NewMovie
                 else raise ArgumentError, 'Фильма такого класса нет'
                 end
      mov_type.new(params)
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
        # rubocop:disable CaseEquality
        filter_value === value
        # rubocop:enable CaseEquality
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
