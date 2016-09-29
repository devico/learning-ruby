module TopMovies

  describe TmdbPosters do

    describe '#take_posters' do

      let(:id_mov) { Tmdb::Find.imdb_id('tt0111161') }
      let(:movie) { Tmdb::Movie.images(id_mov) }
      it 'when return posters' do
        stub_request(:get, "http://api.themoviedb.org/3/find/tt0111161?api_key=d0607e9a2cf6b939168457281815bc4d&external_source=imdb_id").
         with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'}).
         to_return(:status => 200, :body => "", :headers => {})

        VCR.use_cassette 'movie/images' do
          expect(movie['posters']).to be_truthy
        end
      end
    end

    describe '#take_translations' do

      let(:id_mov) { Tmdb::Find.imdb_id('tt0111161') }
      let(:movie) { Tmdb::Movie }
      it 'should return translations for an ID' do
        stub_request(:get, "http://api.themoviedb.org/3/find/tt0111161?api_key=d0607e9a2cf6b939168457281815bc4d&external_source=imdb_id").
         with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'}).
         to_return(:status => 200, :body => "", :headers => {})

        VCR.use_cassette 'movie/translations_for_id' do
          expect(movie.translations(id_mov)['translations']).to be_truthy
        end
      end
    end
  end
end