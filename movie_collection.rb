require 'csv'
require_relative 'cash_box'
require_relative 'filter_genre'
require_relative 'country_filter'
require 'money'
require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'ruby-progressbar'
require 'themoviedb-api'

module TopMovies
  class MovieCollection
    include Enumerable
    include CashBox

    attr_accessor :collection

    def initialize(file_name)
      @collection = make_collection(file_name)
      @balance = Money.new(0, 'UAH')
      @filter = {}
      Tmdb::Api.key("d0607e9a2cf6b939168457281815bc4d")
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
      @genres ||= setup_genre_methods
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

    def by_country
      country_filter = CountryFilter.new(@collection)
      country_filter
    end

    def get_budget
      file_name = "budget.yml"
      if File.exist?(file_name)
        thing = YAML.load_file(file_name)
        puts thing
      else
        budgetfile = File.open(file_name, "w")
        progressbar = ProgressBar.create
        progressbar.total = @collection.size
        @collection.map do |film|
          page = Nokogiri::HTML(open(film.link))
          # puts page.class   # => Nokogiri::HTML::Document
          #tl = page.css('.originalTitle').map { |el| el.text }
          bd = page.css('div.txt-block:nth-child(11)').map { |el| el.text.split(' ')[1] }
          data = { 'title' => film.title, 'budget' => bd[0] }.to_yaml
          budgetfile.puts data
          progressbar.increment
        end
        budgetfile.close
      end
    end

    def get_posters_translations
      @collection.map do |film|
        imdb_id = film.link.scan(/tt\d{7}/).first
        id_mov = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id').first.id
        puts Tmdb::Movie.posters(id_mov)
        puts Tmdb::Movie.translations(id_mov)
      end
    end
  end
end
