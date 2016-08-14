describe NewMovie do

  let(:netflix) { Netflix.new("movies.txt") }
  let(:movie) { netflix.filter(period: :new).first }

  describe '#cost' do
    subject { movie }
    context 'when ask cost that movie return 5.0' do
      its(:cost){ is_expected.to eq(5.0) }
    end
  end

  describe '#period' do
    subject { movie }
    context 'when ask type movie return :new' do
      its(:period){ is_expected.to eq(:new) }
    end
  end

  describe '#show' do
    subject { movie.show }
    context 'when show movie puts in format: Title — новинка, вышло столько то лет назад!' do
      let(:year) { Time.now.year - movie.year }
      let(:value) { "#{movie.title} — новинка, вышло #{year} лет назад!" }
      it { expect( subject ).to eq(value) }
    end
  end

end