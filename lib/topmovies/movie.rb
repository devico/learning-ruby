require_relative '../../www/imdb_budgets'
require_relative '../../www/tmdb_posters'
module TopMovies
  class Movie
    require 'virtus'
    include Virtus.model
    include ImdbBudgets
    include TmdbPosters

    class SplitArray < Virtus::Attribute
      def coerce(value)
        value.split(',')
      end
    end

    attribute :link, String
    attribute :title, String
    attribute :year, Fixnum
    attribute :country, String
    attribute :date, String
    attribute :genre, SplitArray
    attribute :length, String
    attribute :rate, String
    attribute :author, Array
    attribute :actors, SplitArray
    attribute :collection, @collection

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
      mov_type.new(params)
    end

    def match?(filter_name, filter_value)
      value = if filter_value.is_a? Symbol
                send(filter_name).to_s[11..-1].to_sym
              else
                send(filter_name)
              end
      if value.is_a? Array
        value.any? do |v|
          filter_value.is_a?(Array) ? filter_value.include?(v) : v.include?(filter_value)
        end
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
        collection.genre_exists?(type_of_genre)
      genre.include?(type_of_genre)
    end

    def show
      start_time = Time.now
      end_time = start_time + length.to_i * 60
      "Now showing: #{title} #{start_time.strftime('%H:%M')}
        - #{end_time.strftime('%H:%M')}"
    end

    def period
      self.class.to_s.chomp('Movie').downcase.to_sym
    end

    def imdb_id
      link.scan(/tt\d{7}/).first
    end

    def budget
      Dir.chdir File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data', 'budgets'))
      file_name = "#{imdb_id}.yml"
      take_budget_from_imdb(imdb_id) unless File.exist?(file_name)
      take_budget_from_file(file_name)
    end

    def poster
      take_poster(imdb_id)
    end
  end
end
