module TopMovies
  class Period

    attr_accessor :seance, :specification, :filtres, :cost, :saloon, :name

    def initialize(period, &block)
      @seance = period
      instance_eval &block
    end

    def description(descr)
      @specification = descr
    end

    def filters(value = nil)
      return @filters unless value
      @filtres = value
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

    def intersect?(current)
        if seance.include?(current.seance.first && current.seance.last)
          saloon.any? { |s| current.saloon.include?(s) }
        else
          return false
        end
    end
  end
end