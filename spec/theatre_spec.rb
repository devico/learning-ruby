describe Theatre do

  let(:theatre) { Theatre.new("movies.txt")}

  describe '#time_to_show' do
    subject { theatre.time_to_show(params) }
    context 'when is an afternoon' do
      let(:params) { '15:20' }
      it { expect( subject ).to eq(:afternoon) }
    end
  end

  describe '#show' do
    subject{ theatre.show(params)}
    context 'when is morning' do
      let(:params) { '13:20' }
      it { is_expected.to be_a ModernMovie }
    end
  end

  describe '#when?' do
    it { expect( theatre.when?(title: 'Vertigo') ).to eq(:evening) }
  end
end