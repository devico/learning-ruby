module TopMovies
  class FilterGenre

    attr_accessor :collect, :name

    def initialize(collection)
      @collect = collection
    end

    def obtain_genre_methods
      @genres ||= @collect.map(&:genre).flatten.uniq
      @genres.map do |dm|
        self.class.send(:define_method, dm.downcase) do
          @collect.select { |c| c.genre.include?(dm) }
        end
      end
    end
  end
end