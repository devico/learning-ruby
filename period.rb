module TopMovies
  class Period

    attr_accessor :seance, :specification, :filtry, :cost, :saloon, :name

    def initialize(period, &block)
      @seance = period
      instance_eval &block
    end

    def description(descr)
      @specification = descr
    end

    def filters(fltrs)
      @filtry = fltrs
    end

    def price(price)
      @cost = price
    end

    def hall(*hall)
      @saloon = hall
    end

    def title(ttl)
      @name = ttl
    end

  end
end