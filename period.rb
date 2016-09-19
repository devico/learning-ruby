module TopMovies
  class Period
    attr_accessor :seance, :specification, :filtres, :cost, :saloon, :name

    def initialize(period, &block)
      @seance = period
      instance_eval(&block)
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

    def seance_intersect?(current)
      seance.include?(current.seance.first) || seance.include?(current.seance.last)
    end

    def saloon_intersect?(current)
      !(saloon & current.saloon).empty?
    end
  end
end
