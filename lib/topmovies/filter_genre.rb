module TopMovies
  class FilterGenre
    attr_accessor :collect, :name

    def initialize(collection)
      @collect = collection
      setup_genre_methods
    end

    private

    def setup_genre_methods
      @genres ||= @collect.map(&:genre).flatten.uniq
      @genres.map do |dm|
        self.class.send(:define_method, dm.downcase) do
          @collect.select { |c| c.genre.include?(dm) }
        end
      end
    end
  end
end
