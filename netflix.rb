module TopMovies
  class Netflix < MovieCollection
    extend CashBox

    Money.use_i18n = false

    def self.cash
      cashbox_balance
    end

    attr_reader :balance

    def make_payment(movie)
      raise ArgumentError, 'В базе нет такого фильма' unless movie
      if @balance.to_f < movie.cost
        raise ArgumentError, "Для просмотра #{movie.title} нужно еще пополнить \
баланс на #{movie.cost - @balance.to_f}"
      else
        @balance -= to_money(movie.cost)
      end
    end

    def define_filter(filter_name, &block)
      @filter.store(filter_name, block)
    end

    def parse_filters(filters)
      @custom_filters, @inner_filters = filters.partition do |flt|
        @filter.include?(flt[0])
      end
    end

    def filter_movie(filters, &block)
      movies = @collection.dup
      movies = find_by_block(movies, &block)
      movies = find_by_custom_filters(movies, filters)
      movies = find_by_inner_filters(movies, filters)
      movie = movies.sort_by { |m| m.rate.to_f * rand(1000) }.last
      movie
    end

    def find_by_block(movies, &block)
      movies = movies.select(&block) if block_given?
      movies
    end

    def find_by_custom_filters(movies, filters)
      parse_filters(filters)
      if @custom_filters.empty?
        movies
      else
        @custom_filters.each do |k, _v|
          movies = movies.select { |film| @filter[k].call(film) }
        end
      end
      movies
    end

    def find_by_inner_filters(movies, filters)
      parse_filters(filters)
      if @inner_filters.empty?
        movies
      else
        movies = movies.select { |m| m.matches_all?(@inner_filters) }
      end
      movies
    end

    def show(filter_name = {}, &block)
      movie = filter_movie(filter_name, &block)
      make_payment(movie)
      movie.show
    end

    def rand_high_rate(col_movies)
      col_movies.sort_by { |m| m.rate.to_f * rand(1000) }.last
    end

    def pay(payment)
      money = Money.new(payment * 100, 'UAH')
      raise ArgumentError,
            "Ожидается положительное число, получено #{money}" if payment <= 0
      put_to_cashbox(money)
      self.class.put_to_cashbox(money)
      @balance += money
    end

    def film_costs(title)
      movie = filter(title).first
      raise NameError, 'В базе нет такого фильма' unless movie
      to_money(movie.cost)
    end

    def to_money(price)
      Money.new(price * 100, 'UAH')
    end
  end
end
