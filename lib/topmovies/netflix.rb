module TopMovies
  class Netflix < MovieCollection
    extend CashBox

    Money.use_i18n = false

    # show amount money in cashbox
    # @note called when you need to know how much money in cashbox
    # @return [Fixnum] @balance
    def self.cash
      cashbox_balance
    end

    attr_reader :balance

    # withdraw money from the cashbox for preview movie
    # @note called from #show
    # @param
    #   movie [Movie] movie to shown
    # @return [Fixnum] @balance
    def make_payment(movie)
      raise ArgumentError, 'В базе нет такого фильма' unless movie
      if @balance.to_f < movie.cost
        raise ArgumentError, "Для просмотра #{movie.title} нужно еще пополнить \
баланс на #{movie.cost - @balance.to_f}"
      else
        @balance -= to_money(movie.cost)
      end
    end

    # define filter
    # @note called from #show
    # @param
    #   filter_name [Symbol] name new filter
    #   from: [Symbol] name filter on which the new filter is created
    #   arg: [Array] value property of the movie, that define in based filter
    #   &block [Proc] code block containing the filter condition
    # @return [Hash] @filter
    # @example
    #   define_filter(:new_sci_fi) { |movie, year| movie.year > year }
    #   define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)
    def define_filter(filter_name, from: nil, arg: nil, &blk)
      @filter[filter_name] =
        if block_given?
          blk
        elsif !from.nil? && !arg.nil?
          proc { |film, value| @filter[from].call(film, value) }
        else
          raise ArgumentError, 'Невозможно создать пользовательский фильтр'
        end
    end

    # split filters to internal and external
    # @note called from find_by_custom_filters and find_by_inner_filters
    # @param
    #   filters [Hash] filters represents as hash
    # @return [Array] @custom_filters and @inner_filters
    def parse_filters(filters)
      @custom_filters, @inner_filters = filters.partition do |flt|
        @filter.include?(flt[0])
      end
    end

    # get movie that will show
    # @note called from #show
    # @param
    #   filters [Hash] show filters represents as hash
    #   &block [Proc] show filters represents as block
    # @return [Movie] movie
    # @example
    #   filter_movie(new_sci_fi: true)
    #   # => Blade Runner — современное кино:
    def filter_movie(filters, &block)
      movies = @collection.dup
      movies = find_by_block(movies, &block)
      movies = find_by_custom_filters(movies, filters)
      movies = find_by_inner_filters(movies, filters)
      movie = movies.sort_by { |m| m.rate.to_f * rand(1000) }.last
      movie
    end

    # get movies if send block into
    # @note called when send block
    # @param
    #   movies [MovieCollection] movies collection
    #   &block [Proc] it filter represents as block
    # @return [Array] array movies
    # @example
    #   find_by_block(movies, &block)
    def find_by_block(movies, &block)
      movies = movies.select(&block) if block_given?
      movies
    end

    # get movies filetred composite filters
    # @note called when define custom filter
    # @param
    #   movies [MovieCollection] movies collection
    #   filters [Hash] filters represents as hash
    # @return [Array] array movies
    # @example
    #   netflix.find_by_custom_filters(@collection, new_sci_fi: true)
    #   # => Blade Runner — современное кино: играют Harrison Ford, Rutger Hauer, Sean Young
    def find_by_custom_filters(movies, filters)
      parse_filters(filters)
      if @custom_filters.empty?
        movies
      else
        @custom_filters.each do |k, v|
          movies = movies.select do |film|
            @filter[k].call(film, v)
          end
        end
      end
      movies
    end

    # get movies filetred inner filters
    # @note called as needed
    # @param
    #   movies [MovieCollection] movies collection
    #   filters [Hash] filters represents as hash
    # @return [Array] array movies
    # @example
    #   netflix.find_by_inner_filters(@collection, genre: 'Drama')
    #   # => Pulp Fiction — современное кино: играют John Travolta, Uma Thurman, Samuel L. Jackson
    def find_by_inner_filters(movies, filters)
      parse_filters(filters)
      if @inner_filters.empty?
        movies
      else
        movies = movies.select { |m| m.matches_all?(@inner_filters) }
      end
      movies
    end

    # show movie
    # @note called as needed
    # @param
    #   filter_name [Hash] filter name
    #   block [Proc] composite filter represented as a block
    # @return [Movie] film in a certain format
    # @example
    #   netflix.show(genre: 'Drama', period: :new)
    #   # => The Departed — новинка, вышло 10 лет назад!
    #   movie = netflix.show do |movie|
    #     !movie.title.include?('Terminator') && \
    #     movie.genre[0].include?('Action') && \
    #     movie.year > 2003
    #   end
    #   # => The Dark Knight Rises — новинка, вышло 4 лет назад!
    def show(filter_name = {}, &block)
      movie = filter_movie(filter_name, &block)
      make_payment(movie)
      movie.show
    end

    # get movie with high rate
    # @note called as needed
    # @param col_movies [MovieCollection] movies collection
    # @return [Movie] movie with high rate
    # @example
    #   rand_high_rate(col_movies)
    def rand_high_rate(col_movies)
      col_movies.sort_by { |m| m.rate.to_f * rand(1000) }.last
    end

    # put cash to cashbox of Netflix
    # @note called as needed
    # @param payment [Fixnum] amount of payment
    # @return [Fixnum] the amount of money at the cashbox
    # @example
    #   netflix.pay(35)
    #   # => 35.00
    def pay(payment)
      money = Money.new(payment * 100, 'UAH')
      raise ArgumentError,
            "Ожидается положительное число, получено #{money}" if payment <= 0
      put_to_cashbox(money)
      self.class.put_to_cashbox(money)
      @balance += money
    end

    # define the cost of the film by title
    # @note called as needed
    # @param title [String] title movie
    # @return [Money] movie cost in currency format
    # @example
    #   netflix.film_costs('Terminator')
    #   # => 50.00 ₴
    def film_costs(title)
      movie = filter(title).first
      raise NameError, 'В базе нет такого фильма' unless movie
      to_money(movie.cost)
    end

    # converts number into a currency format
    # @note called as needed
    # @param price [Fixnum] ticket cost
    # @return [Money] ticket cost with currency symbol
    # @example
    #   to_money(35.00)
    #   # => 35.00 ₴
    # @see Money
    def to_money(price)
      Money.new(price * 100, 'UAH')
    end
  end
end
