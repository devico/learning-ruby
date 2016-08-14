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
    let(:params) { '10:20' }
    it { is_expected.to be_a AncientMovie }
  end

  describe '#when?' do
    it { expect( theatre.when?(title: 'Vertigo') ).to eq(:evening) }
  end

  describe '#filters_to_hash' do
    subject { theatre.filters_to_hash(params) }
    let(:params) { { genre: ['Comedy', 'Adventure']} }
    let(:value) { [{:genre=>"Comedy"}, {:genre=>"Adventure"}] }
    it { expect( subject ).to eq(value) }
  end

end