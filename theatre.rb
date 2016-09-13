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
        p = TopMovies::Period.new(name, &block)
        v = @periods.any? do |k|
          k.saloon.any? { |s| p.saloon.include?(s) } if k.seance.include?(name.first && name.last)
        end
        if v
          raise ArgumentError, 'Невозможно добавить период, так как этот зал занят'
        else
          @periods.push(p)
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

    def buy_ticket(time_show)
      period = select_period(time_show)
      movie = show(period)
      check = Money.new(period.cost*100, 'UAH')
      put_to_cashbox(check)
      puts "#{period.specification} - #{period.seance}"
      puts "Фильм: #{movie.title}"
      puts "Стоимость: #{check.format}"
    end

    def select_period(arg)
      period = @periods.select { |p| p.seance.include?(arg) }
      period = if period.size > 1
        puts "В это время есть #{period.size} сеанса: "
        period.each { |p| puts "- #{p.seance}" }
        puts "сделайте свой выбор: 1-#{period.size}"
        v = gets.chomp.to_i
        period[v-1]
      else
        period[0]
      end
      period
    end

    def show(period)
      movie = if period.name
        filter(title: period.name).first
      else
        movies = period.filtry.map do |k, v|
          if k == :exclude_country
            filter_exlude(country: v)
          else
            filter(k => v)
          end
        end
        movies.flatten
              .sort_by { |m| m.rate.to_f * rand(1000) }.last
      end
      movie
    end

    def filter_exlude(filters)
      filters.reduce(@collection) do |filtered, (name, value)|
        filtered.reject { |f| f.match?(name, value) }
      end
    end

  end
end
