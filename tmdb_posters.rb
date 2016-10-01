require 'themoviedb'
module TmdbPosters
  def take_posters
    @collection.map do |film|
      id_imdb = film.imdb_id
      id_mov = imdb_to_tmdb(id_imdb)
      Tmdb::Movie.detail(id_mov)['poster_path']
    end
  end

  def take_translations
    @collection.map do |film|
      id_imdb = film.imdb_id
      id_mov = imdb_to_tmdb(id_imdb)
      Tmdb::Movie.translations(id_mov)['translations']
    end
  end

  def imdb_to_tmdb(id_imdb)
    Tmdb::Find.imdb_id(id_imdb).first[1][0]['id']
  end
end
