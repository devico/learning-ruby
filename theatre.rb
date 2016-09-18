require_relative 'period'

module TopMovies
  class Theatre < MovieCollection

    attr_accessor :halls, :periods

    def initialize(&block)
      super('movies.txt')
      @halls = {}
      @periods = []
      @blck = {}
      instance_eval &block
    end

    def hall(name, description)
      @halls[name] = description
    end

    def period(name, &block)
      if @periods.empty?
        @periods.push(TopMovies::Period.new(name, &block))
      else
        new_period = TopMovies::Period.new(name, &block)
        verified_period = @periods.any? { |other| other.intersect?(new_period) }
        if verified_period
          raise ArgumentError, 'Невозможно добавить период, так как этот зал занят'
        else
          @periods.push(new_period)
        end
      end
    end

    PERIOD_DAY = { morning: (8..12), afternoon: (13..16), evening: (17..23),
                   night: (0..7) }.freeze
    DAY_PRICE = { morning: 3.0, afternoon: 5.0, evening: 10.0 }.freeze
    FILTERS_MOVIE = { morning: { period: :ancient },
                      afternoon: { genre: %w(Comedy Adventure) },
                      evening: { genre: %w(Drama Mystery) } }.freeze

    def time_to_show(time)
      hour = DateTime.strptime(time, '%H').hour
      period = PERIOD_DAY.select { |_k, v| v.include?(hour) }.keys[0]
      raise ArgumentError,
            'В ночное время кинотеатр не работает' if period == :night
      period
    end

    def when?(title)
      movie = filter(title).first
      period = FILTERS_MOVIE.find_all do |_per, fil|
        filters_to_hash(fil).detect { |k| movie.matches_all?(k) }
      end
      period.flatten[0]
    end

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

    def buy_ticket(time_show, hall = nil)
      period = select_period(time_show, hall)
      movie = show(period)
      check = Money.new(period.cost * 100, 'UAH')
      put_to_cashbox(check)
      result = "#{period.specification} - #{period.seance} : \
Фильм: #{movie.title} - #{check.format}"
      result
    end

    def select_period(time, hall)
      period = @periods.select { |p| p.seance.include?(time) }
      pr = if period.size > 1
             period.select { |p| p.saloon.include?(hall[:hall])}
           else
             period[0]
           end
      selected_period = hall.nil? ? pr : pr[0]
      selected_period
    end

    def show(period)
      movie =
        if period.name
          filter(title: period.name).first
        else
          mov = @collection.dup
          movies = period.filtres.inject(mov) do |films, fil|
            if fil[0] == :exclude_country
              films = films.reject { |f| f.matches_all?(country: fil[1]) }
            else
              films = films.select { |f| f.matches_all?(fil[0] => fil[1]) }
            end
            films
          end
          movies.flatten.sort_by { |m| m.rate.to_f * rand(1000) }.last
        end
      movie
    end
  end
end
