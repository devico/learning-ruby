module TopMovies
  class CountryFilter
    attr_accessor :collect

    def initialize(collection)
      @collect = collection
    end

    def respond_to_missing?(name)
    end

    def method_missing(name)
      @collect.select { |c| c.country.include?(name.to_s.upcase) }
      super
    end
  end
end
