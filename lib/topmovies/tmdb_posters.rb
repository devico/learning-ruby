module TopMovies
  module TmdbPosters
    def take_posters
      @collection.map do |film|
        Tmdb::Movie.detail(imdb_to_tmdb(film.imdb_id))['poster_path']
      end
    end

    def take_translations
      @collection.map do |film|
        Tmdb::Movie.translations(imdb_to_tmdb(film.imdb_id))['translations']
      end
    end

    def imdb_to_tmdb(id_imdb)
      Tmdb::Find.imdb_id(id_imdb).first[1][0]['id']
    end

    def take_poster(*)
      Tmdb::Movie.detail(imdb_to_tmdb(imdb_id))['poster_path']
    end
  end
end
