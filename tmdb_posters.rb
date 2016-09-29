require 'themoviedb-api'
module TmdbPosters
  def take_posters_translations
    @collection.map do |film|
      imdb_id = film.link.scan(/tt\d{7}/).first
      id_mov = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id').first.id
      Tmdb::Movie.posters(id_mov).first
      Tmdb::Movie.translations(id_mov)
    end
  end
end
