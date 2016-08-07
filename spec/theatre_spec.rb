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
      let(:params) { '10:20' }
      it { is_expected.to be_a AncientMovie }
    end
  end

  describe '#when?' do
    subject { theatre.when?(params)}
    context 'when show' do
      let(:params) { {title: 'The Terminator'} }
      it { expect( subject ).to eq([:evening, :morning]) }
    end
  end
end