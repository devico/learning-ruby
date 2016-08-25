module TopMovies
  class Netflix < MovieCollection
    extend CashBox

    Money.use_i18n = false

    def self.cash
      cashbox_balance
    end

    attr_reader :balance

    def find_movie(params)
      movie = filter(params).sort_by { |m| m.rate.to_f * rand(1000) }.last
      raise NameError, 'В базе нет такого фильма' unless movie
      movie
    end

    def make_payment(movie)
      if @balance.to_f < movie.cost
        raise ArgumentError, "Для просмотра #{movie.title} нужно еще пополнить \
баланс на #{movie.cost - @balance.to_f}"
      else
        @balance -= to_money(movie.cost)
      end
    end

    def define_filter(filter_name, &block)
      @filter = { filter_name => block }
    end

    def show(filter_name = {}, &block)
      if !block_given? && filter_name.empty?
        raise ArgumentError, 'Необходимо указать параметры поиска'
      elsif !filter_name.empty?
        filter_name.each do |k, v|
          if @filter
            show_with_filters if @filter.include?(k) && v
          else
            show_without_filters(k => v)
          end
        end
        show_with_blocks(&block) if block_given?
      elsif block_given?
        show_with_blocks(&block)
      end
    end

    def show_with_blocks(&block)
      movie = rand_high_rate(@collection.select(&block))
      make_payment(movie)
      puts movie.show
    end

    def show_with_filters
      movies = @collection.select { |film| @filter.values[0].call(film) }
      movie = rand_high_rate(movies)
      make_payment(movie)
      puts movie.show
    end

    def show_without_filters(filter_name)
      movie = find_movie(filter_name)
      make_payment(movie)
      puts movie.show
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
