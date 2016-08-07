describe ClassicMovie do

  let(:netflix) { Netflix.new("movies.txt") }
  let(:movie) { netflix.filter(period: :classic).first }

  describe '#cost' do
    subject { movie.cost }
    context 'when ask cost that movie return 1.5' do
      it { is_expected.to eq(1.5) }
    end
  end

  describe '#period' do
    subject { movie.period }
    context 'when ask type movie return :classic' do
      it { is_expected.to eq(:classic) }
    end
  end

  describe '#show' do
    subject { movie.show }
    context 'when show movie puts in format: Title — классический фильм, режиссёр author' do
      let(:value) { "#{movie.title} — классический фильм, режиссёр #{movie.author}" }
      it { expect( subject ).to eq(value) }
    end
  end

end