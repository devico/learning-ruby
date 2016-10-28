module TopMovies

  describe TmdbPosters do

    describe '#take_posters' do
      let(:id_mov) { Tmdb::Find.imdb_id('tt0111161') }
      let(:movie) { Tmdb::Movie.images(id_mov) }
      let(:value) { "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg"}
      it 'when return posters' do
        VCR.use_cassette "tmdb/posters" do
          expect(movie['posters']).to eq(value)
        end
      end
    end

    describe '#take_translations', vcr: true do
      let(:id_mov) { Tmdb::Find.imdb_id('tt0111161') }
      let(:movie) { Tmdb::Movie }

      it 'should return translations for an ID' do
        #VCR.use_cassette "tmdb/translations" do
          expect(movie.translations(id_mov)['translations']).to be_truthy
        #end
      end
    end

    describe '#imdb_to_tmdb' do
      let(:movies) { TopMovies::MovieCollection.new(DEFAULT_MOVIES_PATH) }
      let(:film) { movies.all.first }
      let(:id_imdb) { film.link.scan(/tt\d{7}/).first }
      it 'when imdb_id convert to tmdb_id' do
        VCR.use_cassette 'tmdb/tmdb_id' do
          expect(movies.imdb_to_tmdb(id_imdb)).to eq(278)
        end
      end
    end

  end
end