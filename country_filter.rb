module TopMovies
  class CountryFilter

    attr_accessor :collect

    def initialize(collection)
      @collect = collection
    end

    def method_missing name, *args, &block
      films = @collect.select { |c| c.country.include?(name.to_s.upcase) }
      films
    end

  end
end