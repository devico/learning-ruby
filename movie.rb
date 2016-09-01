module TopMovies
  class Movie
    require "virtus"
    include Virtus.model

      attribute :link, String
      attribute :title, String
      attribute :year, Fixnum
      attribute :country, String
      attribute :date, String
      attribute :genre, Array
      attribute :length, String
      attribute :rate, String
      attribute :author, String
      attribute :actors, String

    attr_accessor :link, :title, :year, :country, :date, :genre, :length, :rate,
                  :author, :actors, :period

    require_relative './ancient_movie'
    require_relative './classic_movie'
    require_relative './modern_movie'
    require_relative './new_movie'
    MOVIE_TYPE = { AncientMovie => (1900..1944), ClassicMovie => (1945..1967),
                   ModernMovie => (1968..1999), NewMovie => (2000..2015) }.freeze

    def self.create(params)
      mov_type = MOVIE_TYPE.select { |_k, v| v.include?(params[:year].to_i) }
                           .keys[0]
      raise ArgumentError, 'Фильма такого класса нет' unless mov_type
      mov_type.new(:link => params[:link],
                   :title => params[:title],
                   :year => params[:year].to_i,
                   :country => params[:country],
                   :date => params[:date],
                   :genre => params[:genre].split(','),
                   :length => params[:length],
                   :rate => params[:rate],
                   :author => params[:author],
                   :actors => params[:actors].split(','),
                   @collection => params[:collection])
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
        :collection.genre_exists?(type_of_genre)
      :genre.include?(type_of_genre)
    end

    def show
      start_time = Time.now
      end_time = start_time + :length.to_i * 60
      "Now showing: #{:title} #{start_time.strftime('%H:%M')}
        - #{end_time.strftime('%H:%M')}"
    end

    def period
      self.class.to_s.chomp('Movie').downcase.to_sym
    end
  end
end
