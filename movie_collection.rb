require 'csv'
require_relative 'cash_box'
require_relative 'filter_genre'
require 'money'

module TopMovies
  class MovieCollection
    include Enumerable
    include CashBox

    attr_accessor :collection

    def initialize(file_name)
      @collection = make_collection(file_name)
      @balance = Money.new(0, 'UAH')
      @filter = {}
    end

    def make_collection(name_file)
      CSV.read(name_file, col_sep: '|', headers:
         %i(link title year country date genre length rate author actors))
         .map(&:to_hash).map do |film|
        Movie.create(
          { link: film[:link], title: film[:title], year: film[:year],
            country: film[:country], date: film[:date], genre: film[:genre],
            length: film[:length], rate: film[:rate], author: film[:author],
            actors: film[:actors] }.merge(collection: self)
        )
      end
    end

    def make_movie
      @collection
    end

    def all
      @collection
    end

    def first_movie
      @collection.first
    end

    def sort_by(filter)
      @collection
        .sort_by(&filter)
        .map { |c| puts "#{c.title} - #{c.send(filter)}" }
    end

    def filter(filters)
      filters.reduce(@collection) do |filtered, (name, value)|
        filtered.select { |f| f.match?(name, value) }
      end
    end

    def stats(movie_field)
      @collection.map(&movie_field).flatten.group_by(&:itself)
                 .map { |k, v| [k, v.count] }.sort.to_h
    end

    def genre_exists?(genre_film)
      @genres ||= obtain_genres
      @genres.include?(genre_film)
    end

    def cash
      cashbox_balance
    end

    def obtain_genres
      @genres ||= @collection.map(&:genre).flatten.uniq
    end

    def by_genre
      filter_genre = FilterGenre.new(@collection)
      filter_genre
    end

  end
end
