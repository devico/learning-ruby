module TopMovies
  class CountryFilter
    attr_accessor :collect

    def initialize(collection)
      @collect = collection
    end

    def respond_to_missing?(method_name)
      method_name
    end

    def method_missing(method_name)
      @collect.select { |c| c.country.include?(method_name.to_s.upcase) }
    end
  end
end
