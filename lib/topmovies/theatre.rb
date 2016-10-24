require_relative 'period'

module TopMovies
  class Theatre < MovieCollection
    attr_accessor :halls, :periods

    PATH_DATA = File.expand_path('data/movies.txt', __dir__)

    def initialize(&block)
      super(PATH_DATA)
      @halls = {}
      @periods = []
      @blck = {}
      instance_eval(&block)
    end

    # Add hall to Theatre
    # @note called when created Theatre
    #   Hall is the place showing of the movie and will be used
    #   in the methods of adding periods and buy tickets
    # @param name [Symbol] name hall
    # @param description [Hash] description hall (title, places)
    # @return [Hash] @halls
    # @example
    #   hall(:red, {title: 'Красный зал', places: 100})
    def hall(name, description)
      @halls[name] = description
    end

    # Add period to Theatre
    # @note called when created Theatre
    #   Period this is schedule, which indicates the hall and time for show movie,
    #   presence of filters and the cost of tickets, used used when displaying movies
    #   and buying tickets
    # @param name [Range] name period
    # @param block [Proc] data period(description, filters, price, hall)
    # @return [Hash] @periods
    # @example
    #   period '09:00'..'12:00' do
    #     description 'Утренний сеанс'
    #     filters genre: 'Comedy', year: 1900..1980
    #     price 10
    #     hall :red, :blue
    #   end
    def period(name, &block)
      new_period = TopMovies::Period.new(name, &block)
      if @periods.empty?
        @periods.push(new_period)
      elsif verify_period(new_period)
        raise ArgumentError, 'Невозможно добавить период, так как этот зал занят'
      else
        @periods.push(new_period)
      end
    end

    # Check the period added to the schedule on intesection time
    # @param current [TopMovies::Period] period added
    # @return [Boolean]
    def verify_period(current)
      @periods.any? { |p| p.intersects?(current) }
    end

    PERIOD_DAY = { morning: (8..12), afternoon: (13..16), evening: (17..23),
                   night: (0..7) }.freeze
    DAY_PRICE = { morning: 3.0, afternoon: 5.0, evening: 10.0 }.freeze
    FILTERS_MOVIE = { morning: { period: :ancient },
                      afternoon: { genre: %w(Comedy Adventure) },
                      evening: { genre: %w(Drama Mystery) } }.freeze

    # Get period day for show movie
    # @param time [String] show time
    # @return [Symbol] any hash key from PERIOD_DAY
    # @example
    #   time_to_show('09:00')
    #   # => morning
    def time_to_show(time)
      hour = DateTime.strptime(time, '%H').hour
      period = PERIOD_DAY.select { |_k, v| v.include?(hour) }.keys[0]
      raise ArgumentError,
            'В ночное время кинотеатр не работает' if period == :night
      period
    end

    # Know when show movie by title
    # @note based on check type of movie (ancient, classic, modern, new)
    # @param title [String] movie title
    # @return [Symbol] any hash key from FILTERS_MOVIE
    # @example
    #   when?('Terminator')
    #   # => afternoon
    def when?(title)
      movie = filter(title).first
      period = FILTERS_MOVIE.find_all do |_per, fil|
        filters_to_hash(fil).detect { |k| movie.matches_all?(k) }
      end
      period.flatten[0]
    end

    # Converts filters to hash
    # @note called in #when?
    # @param filters [Array]
    # @return [Hash]
    # filters_to_hash({ genre: ['Comedy', 'Adventure']})
    #  # => { genre: 'Comedy', genre: 'Adventure'}
    def filters_to_hash(filters)
      flts = filters.map do |k, v|
        if v.is_a?(Array)
          v.map { |gen| Hash[k, gen] }
        else
          Hash[k, v]
        end
      end
      flts.flatten
    end

    # Buy a ticket to a movie at a certain time, you can specify the hall
    # @param time_show [String] show time
    # @param hall [Hash] name hall
    # @return [String]
    # @example
    #   buy_ticket('17:20')
    #   # => Вечерний сеанс - 16:00..20:00 : Фильм: The Hunt - 20.00 ₴
    #   buy_ticket('19:20', hall: :green)
    #   # => Вечерний сеанс для киноманов - 19:00..22:00 : Фильм: Modern Times - 30.00 ₴
    def buy_ticket(time_show, hall = nil)
      period = select_period(time_show, hall)
      movie = show(period)
      check = Money.new(period.cost * 100, 'UAH')
      put_to_cashbox(check)
      result = "#{period.specification} - #{period.seance} : \
Фильм: #{movie.title} - #{check.format}"
      result
    end

    # Select period for movie show when halls intersects
    # @param time [String] show movie time
    # @param hall [Hash] hall name
    # @return [String] period name
    # @example
    #   select_period('19:20', hall: :green)
    #   # => <TopMovies::Period:0x0000000123bee0>
    def select_period(time, hall)
      period = @periods.select { |p| p.seance.include?(time) }
      pr = if period.size > 1
             period.select { |p| p.saloon.include?(hall[:hall]) }
           else
             period[0]
           end
      selected_period = hall.nil? ? pr : pr[0]
      selected_period
    end

    # Show the movie according to the period
    # @param period [TopMovies::Period]
    # @return [Movie]
    # @example
    #   show('19:20', hall: :green)
    #   # => <TopMovies::AncientMovie:0x00000002d5fe10>
    def show(period)
      if period.name
        filter(title: period.name).first
      else
        get_movie_from_filters(period)
      end
    end

    # Get filtered movie with high rate
    # @note called from #show
    # @param period [TopMovies::Period]
    # @return [Movie]
    # @example
    #   get_movie_from_filters('19:20', hall: :green)
    #   # => <TopMovies::AncientMovie:0x000000032a5988>
    def get_movie_from_filters(period)
      mov = @collection.dup
      movies = period.filtres.inject(mov) do |films, (key, value)|
        key = :country if key == :exclude_country
        films.select { |f| f.matches_all?(key => value) }
      end
      movies.flatten.sort_by { |m| m.rate.to_f * rand(1000) }.last
    end
  end
end
