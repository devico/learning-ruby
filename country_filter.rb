module TopMovies
  class CountryFilter
    attr_accessor :collect

    def initialize(collection)
      @collect = collection
    end

    def respond_to_missing?(method_name)
      if method_name =~ /(\?|\.|\=)$/
        super
      else
        true
      end
    end

    def method_missing(method_name)
      if method_name =~ /(\?|\.|\=)$/
        super
      else
        @collect.select { |c| c.country.include?(method_name.to_s.upcase) }
      end
    end
  end
end
