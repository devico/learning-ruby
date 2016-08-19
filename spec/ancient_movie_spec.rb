module TopMovies

  describe AncientMovie do

    let(:netflix) { TopMovies::Netflix.new("movies.txt") }
    let(:movie) { netflix.filter(period: :ancient).first }

    describe '#cost and #period' do
      subject { movie }
      its(:cost){ is_expected.to eq(1.0) }
      its(:period){ is_expected.to eq(:"topmovies::ancient") }
    end

    describe '#show' do
      subject { movie.show }
      context 'when show movie puts in format: Title — старый фильм (год)' do
        let(:value) { "#{movie.title} — старый фильм (#{movie.year} год)" }
        it { expect( subject ).to eq(value) }
      end
    end

  end

end