module TopMovies

  describe Movie do

    describe '#self.create' do

        let(:params) { ["http://imdb.com/title/tt0017925/?ref_=chttp_tt_136", "The General", year, "USA", "1927-02-24", "Action,Adventure,Comedy", "67 min", "8.3", "Clyde Bruckman", "Buster Keaton,Marion Mack,Glen Cavender", self] }

      subject { Movie.create(*params) }

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
      let(:theatre) { Theatre.new("movies.txt")}
      let(:movie) { theatre.filter(genre: 'Comedy').first }
      let(:params) { {genre: ['Comedy', 'Drama'], year: 1993...1998} }
      it { expect( subject ).to be_truthy }
    end

  end

end