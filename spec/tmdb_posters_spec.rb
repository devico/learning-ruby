module TopMovies

  describe TmdbPosters do
    let(:collection) { TopMovies::MovieCollection.new('movies.txt') { include TmdbPosters } }

    describe '#take_posters_translations' do

      context 'when get posters' do
        let(:film) { collection.all.first }
        let(:id_imdb) { film.link.scan(/tt\d{7}/).first }
        let(:id_tmdb) { Tmdb::Find.movie(id_imdb, external_source: 'imdb_id').first.id }
        it "when take posters" do
          VCR.use_cassette('tmdb/poster') do
            stub_request(:get, "http://api.themoviedb.org/3/find/tt0111161?api_key=d0607e9a2cf6b939168457281815bc4d&external_source=imdb_id").
              with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json; charset=utf-8', 'User-Agent'=>'Ruby'}).
              to_return(:status => 200, :body => "", :headers => {})
            poster = Tmdb::Movie.posters(id_tmdb).first
            expect(poster.class).to be_a Tmdb::Poster
          end
        end
      end
    end
  end
end