module TopMovies

  describe Theatre do

    let(:theatre) do
        TopMovies::Theatre.new do
          hall :red, title: 'Красный зал', places: 100
          hall :blue, title: 'Синий зал', places: 50
          hall :green, title: 'Зелёный зал (deluxe)', places: 12

          period '09:00'..'12:00' do
            description 'Утренний сеанс'
            filters genre: 'Comedy', year: 1900..1980
            price 10
            hall :red, :blue
          end

          period '12:00'..'16:00' do
            description 'Спецпоказ'
            title 'The Terminator'
            price 50
            hall :green
          end

          period '16:00'..'20:00' do
            description 'Вечерний сеанс'
            filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
            price 20
            hall :red, :blue
          end

          period '19:00'..'22:00' do
            description 'Вечерний сеанс для киноманов'
            filters year: 1900..1945, exclude_country: 'USA'
            price 30
            hall :green
          end
        end
      end

    describe '#time_to_show' do
      subject { theatre.time_to_show(params) }
      context 'when is an afternoon' do
        let(:params) { '15:20' }
        it { expect( subject ).to eq(:afternoon) }
      end
    end

    describe '#show' do
      subject{ theatre.show(period)}
      let(:period) { theatre.select_period(time_show, hall) }
      let(:time_show) { '19:20' }
      let(:hall) { {hall: :red} }
      it { expect(subject.genre.include?('Action')).to be_truthy }
      its(:year) { is_expected.to be > 2007 }
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
      subject { theatre.buy_ticket(time_show, hall) }
      let(:time_show) { '19:20' }
      let(:hall) { {hall: :red} }
      let(:output) { /^Вечерний сеанс - 16:00..20:00 : Фильм:(.*) - 20.00 ₴/ }
      it { expect(subject).to match(output)}
    end

    describe '#select_period' do
      subject { theatre.select_period(time_show, hall) }
      let(:time_show) { '19:20' }
      let(:hall) { {hall: :red} }
      it { is_expected.to be_a TopMovies::Period }
    end

    # describe '#buy_ticket' do
    #   let(:start_value) { Money.new(0, "UAH") }

    #   context 'when morning' do
    #     it { expect { theatre.buy_ticket('10:15') }.to change(theatre, :cashbox_balance).from(start_value).to(Money.new(3, "UAH")) }
    #   end

    #   context 'when afternoon' do
    #     it { expect { theatre.buy_ticket('14:35') }.to change(theatre, :cashbox_balance).from(start_value).to(Money.new(5, "UAH")) }
    #   end

    #   context 'when evening' do
    #     it { expect { theatre.buy_ticket('21:00') }.to change(theatre, :cashbox_balance).from(start_value).to(Money.new(10, "UAH")) }
    #   end

    # end

  end

end