module TopMovies
  class Netflix < MovieCollection
    extend CashBox

    Money.use_i18n = false

    def self.cash
      cashbox_balance
    end

    attr_reader :balance

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
      movies = @collection.select(&block) if block_given?
      movies = filter_name.map { |k, v| movies.map { |film| @filter.v.call(film) } } if @filter && block_given?
      if @filter
        filter_name.each do |item_filter|
          movies = filter(item_filter) if !@filter.include?(item_filter[0])
        end
      else
        movies = filter(filter_name)
      end
      movie = movies.sort_by { |m| m.rate.to_f * rand(1000) }.last
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
