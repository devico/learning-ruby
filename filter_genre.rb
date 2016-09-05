module TopMovies
  class FilterGenre

    attr_accessor :collect, :name

    def initialize(collection)
      @collect = collection
      obtain_genre_methods
    end

    def obtain_genre_methods
      @genres ||= @collect.map(&:genre).flatten.uniq
      @genres.map do |dm|
        self.class.send(:define_method, dm.downcase) do
          @collect.select { |c| c.genre.include?(dm) }
        end
      end
    end

    def method_missing name, *args, &block
      self.class.send(:define_method, name, proc { filter(country: name.to_s) } )
    end

  end
end