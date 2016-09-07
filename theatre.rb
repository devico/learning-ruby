module TopMovies
  class Theatre < MovieCollection

    attr_accessor :theatre

    def initialize(file_name)
      super(file_name)
      #accept_description

    end

    PERIOD_DAY = { morning: (8..12), afternoon: (13..16), evening: (17..23),
                   night: (0..7) }.freeze
    DAY_PRICE = { morning: 3.0, afternoon: 5.0, evening: 10.0 }.freeze
    FILTERS_MOVIE = { morning: { period: :ancient },
                      afternoon: { genre: %w(Comedy Adventure) },
                      evening: { genre: %w(Drama Mystery) } }.freeze

    def accept_description
      theater =
        TopMovies::Theatre.new do
          hall :red, title: 'Красный зал', places: 100
          hall :blue, title: 'Синий зал', places: 50
          hall :green, title: 'Зелёный зал (deluxe)', places: 12

          period '09:00'..'11:00' do
            description 'Утренний сеанс'
            filters genre: 'Comedy', year: 1900..1980
            price 10
            hall :red, :blue
          end

          period '11:00'..'16:00' do
            description 'Спецпоказ'
            title 'The Terminator'
            price 50
            hall :green
          end

          period '16:00'..'20:00' do
            description 'Вечерний сеанс'
            filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
            price 20
            hall :red, :blue
          end

          period '19:00'..'22:00' do
            description 'Вечерний сеанс для киноманов'
            filters year: 1900..1945, exclude_country: 'USA'
            price 30
            hall :green
          end
        end
    end

    def time_to_show(time)
      hour = DateTime.strptime(time, '%H').hour
      period = PERIOD_DAY.select { |_k, v| v.include?(hour) }.keys[0]
      raise ArgumentError,
            'В ночное время кинотеатр не работает' if period == :night
      period
    end

    def show(params)
      filters_to_hash(FILTERS_MOVIE.select { |k, _v| k == time_to_show(params) }
        .values[0])
        .map { |fil_mov| filter(fil_mov) }.flatten
        .sort_by { |m| m.rate.to_f * rand(1000) }.last
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
