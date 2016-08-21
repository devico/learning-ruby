module TopMovies
  class Theatre < MovieCollection
    PERIOD_DAY = { morning: (8..12), afternoon: (13..16), evening: (17..23),
                   night: (0..7) }.freeze
    DAY_PRICE = { morning: 3.0, afternoon: 5.0, evening: 10.0 }.freeze
    FILTERS_MOVIE = { morning: { period: :ancient },
                      afternoon: { genre: %w(Comedy Adventure) },
                      evening: { genre: %w(Drama Mystery) } }.freeze

    def time_to_show(time)
      hour = DateTime.strptime(time, '%H').hour
      PERIOD_DAY.select { |_k, v| v.include?(hour) }.keys[0]
    end

    def show(params)
      order_time = time_to_show(params)
      raise ArgumentError,
            'В ночное время кинотеатр не работает' if order_time == :night
      order = FILTERS_MOVIE.select { |k, _v| k == order_time }.values[0]
      movies = filters_to_hash(order).map { |fil_mov| filter(fil_mov) }.flatten
      movies.sort_by { |m| m.rate.to_f * rand(1000) }.last
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
      movie = show(time_show)
      puts "Вы купили билет на #{movie.title}"
      order_time = time_to_show(time_show)
      check = Money.new(DAY_PRICE[order_time], 'UAH')
      put_to_cashbox(check)
    end
  end
end
