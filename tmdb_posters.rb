require 'themoviedb'
module TmdbPosters
  def take_posters
    @collection.map do |film|
      id_imdb = film.link.scan(/tt\d{7}/).first
      id_mov = Tmdb::Find.imdb_id(id_imdb).first[1][0]['id']
      Tmdb::Movie.detail(id_mov)['poster_path']
    end
  end

  def take_translations
    @collection.map do |film|
      id_imdb = film.link.scan(/tt\d{7}/).first
      id_mov = Tmdb::Find.imdb_id(id_imdb).first[1][0]['id']
      Tmdb::Movie.translations(id_mov)['translations']
    end
  end

end
