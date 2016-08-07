describe AncientMovie do

  let(:netflix) { Netflix.new("movies.txt") }
  let(:movie) { netflix.filter(period: :ancient).first }


  describe '#cost' do
    subject { movie }
    context 'when ask cost that movie return 1.0' do
      its(:cost){ is_expected.to eq(1.0) }
    end
  end

  describe '#period' do
    subject { movie }
    context 'when ask type movie return :ancient' do
      its(:period){ is_expected.to eq(:ancient) }
    end
  end

  describe '#show' do
    subject { movie.show }
    context 'when show movie puts in format: Title — старый фильм (год)' do
      let(:value) { "#{movie.title} — старый фильм (#{movie.year} год)" }
      it { expect( subject ).to eq(value) }
    end
  end

end