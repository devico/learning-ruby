module TopMovies

  describe Theatre do

    let(:theatre) { TopMovies::Theatre.new("movies.txt")}

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

    describe '#buy_ticket' do
      let(:start_value) { Money.new(0, "UAH") }

      context 'when morning' do
        it { expect { theatre.buy_ticket('10:15') }.to change(theatre, :cashbox_balance).from(start_value).to(Money.new(3, "UAH")) }
      end

      context 'when afternoon' do
        it { expect { theatre.buy_ticket('14:35') }.to change(theatre, :cashbox_balance).from(start_value).to(Money.new(5, "UAH")) }
      end

      context 'when evening' do
        it { expect { theatre.buy_ticket('21:00') }.to change(theatre, :cashbox_balance).from(start_value).to(Money.new(10, "UAH")) }
      end

    end

  end

end