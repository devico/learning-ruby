module TopMovies

  describe Movie do

    describe '#self.create' do

        let(:params) { { :link=>"http://imdb.com/title/tt0017925/?ref_=chttp_tt_136",
                         :title=>"The General", :year=>year, :country=>"USA",
                         :date=>"1927-02-24", :genre=>"Action,Adventure,Comedy",
                         :length=>"67 min", :rate=>"8.3", :author=>"Clyde Bruckman",
                         :actors=>"Buster Keaton,Marion Mack,Glen Cavender", :collection=>self} }

      subject { Movie.create(params) }

      context 'when year is 1900-1945' do
        let(:year) { 1926 }
        it { is_expected.to be_a AncientMovie }
      end

      context 'when year is 1945-1968' do
        let(:year) { 1962 }
        it { is_expected.to be_a ClassicMovie }
      end

      context 'when year is 1968-2000' do
        let(:year) { 1994 }
        it { is_expected.to be_a ModernMovie }
      end

      context 'when year is over 2000' do
        let(:year) { 2003 }
        it { is_expected.to be_a NewMovie }
      end

    end

    describe '#matches_all?' do
      subject { movie.matches_all?(params) }
      let(:netflix) { Netflix.new("lib/topmovies/data/movies.txt")}
      let(:movie) { netflix.filter(genre: 'Comedy').first }
      let(:params) { {genre: 'Comedy', year: 1983...1998} }
      it { expect( subject ).to be_truthy }
    end

    describe '#imdb_id' do
      subject { movie.imdb_id }
      let(:netflix) { Netflix.new("lib/topmovies/data/movies.txt")}
      let(:movie) { netflix.all.first }
      it { expect( subject ).to eq('tt0111161') }
    end

  end
end