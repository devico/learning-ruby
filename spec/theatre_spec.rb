describe Theatre do

  let(:theatre) { Theatre.new("movies.txt")}

  describe '#time_to_show' do
    subject { theatre.time_to_show(params) }
    context 'when time is 15:20 this is afternoon' do
      let(:params) { '15:20' }
      it { expect( subject ).to eq(:afternoon) }
    end
  end

  describe '#show' do
    subject{ theatre.show(params)}
    context 'when time is 10:20 shown movie class must be AncientMovie' do
      let(:params) { '10:20' }
      it { is_expected.to be_a AncientMovie }
    end
  end

  describe '#when?' do
    subject { theatre.when?(params)}
    context 'when movie show, is an afternoon' do
      let(:params) { {title: 'The Terminator'} }
      it { expect( subject ).to eq(:afternoon) }
    end
  end
end