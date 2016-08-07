describe ModernMovie do

  let(:netflix) { Netflix.new("movies.txt") }
  let(:movie) { netflix.filter(period: :modern).first }

  describe '#cost' do
    subject { movie.cost }
    context 'when ask cost that movie return 3.0' do
      it { is_expected.to eq(3.0) }
    end
  end

  describe '#period' do
    subject { movie.period }
    context 'when ask type movie return :modern' do
      it { is_expected.to eq(:modern) }
    end
  end

  describe '#show' do
    subject { movie.show }
    context 'when show movie puts in format: Title — современное кино: играют actors' do
      let(:value) { "#{movie.title} — современное кино: играют #{movie.actors.join(', ')}" }
      it { expect( subject ).to eq(value) }
    end
  end

end