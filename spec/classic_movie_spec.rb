describe ClassicMovie do

  let(:netflix) { Netflix.new("movies.txt") }
  let(:movie) { netflix.filter(period: :classic).first }

  describe '#cost' do
    subject { movie }
    context 'when ask cost that movie return 1.5' do
      its(:cost){ is_expected.to eq(1.5) }
    end
  end

  describe '#period' do
    subject { movie }
    context 'when ask type movie return :classic' do
      its(:period){ is_expected.to eq(:classic) }
    end
  end

  describe '#show' do
    subject { movie.show }
    context 'when show ClassicMovie' do
      let(:value) { "#{movie.title} — классический фильм, режиссёр #{movie.author}" }
      it { expect( subject ).to eq(value) }
    end
  end

end