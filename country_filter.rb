module TopMovies
  class CountryFilter

    attr_accessor :collect

    def initialize(collection)
      @collect = collection
    end

    def method_missing name, *args, &block
      self.class.send(:define_method, name, proc { @collect.select { |c| c.country.include?(name.to_s.capitalize) } } )
    end

  end
end