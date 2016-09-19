module TopMovies
  class CountryFilter
    attr_accessor :collect

    def initialize(collection)
      @collect = collection
    end

    def method_missing(name)
      @collect.select { |c| c.country.include?(name.to_s.upcase) }
    end
  end
end
