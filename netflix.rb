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

    def show(filter_name = nil)
      if block_given?
        @collection.select { |movie| yield(movie) }
      else
        show_with_filters(filter_name)
      end
    end

    def show_with_filters(filter_name)
      if !@filter
        movie = find_movie(filter_name)
        make_payment(movie)
        movie.show
      elsif @filter.include?(filter_name.keys[0]) && filter_name.values[0]
        @collection.select { |film| @filter.values[0].call(film) }
      else
        raise ArgumentError, 'Не найдено ни одного фильма'
      end
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
