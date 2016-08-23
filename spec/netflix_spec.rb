module TopMovies

  describe Netflix do

    let(:netflix) { TopMovies::Netflix.new("movies.txt") }

    describe '#balance status' do
      subject { netflix }
      its(:balance) { is_expected.to eq(0.0) }
    end

    describe '#pay' do
      it { expect { netflix.pay(25) }.to change(netflix, :balance).from(0).to(Money.new(2500, "UAH")) }
      it { expect { netflix.pay( -2 ) }.to raise_error( ArgumentError, "Ожидается положительное число, получено -2.00" ) }
    end

    describe '#show' do
        before { netflix.pay( 10 ) }
        let(:movie) { netflix.filter(genre: 'Comedy', period: :modern).first }
        subject { movie.show }
        let(:str) { /.*современное кино: играют.*/ }
        it { expect(subject).to match(str) }
    end

    describe '#film_costs' do

      context "when send title" do
        subject { netflix.film_costs(params) }
        let(:movie) { netflix.filter(title: 'The Terminator').first }
        let(:params) { {title: 'The Terminator'} }
        it { expect( subject ).to eq(Money.new(movie.cost*100, "UAH")) }
      end

      context 'when not have movie in base' do
        before { netflix.pay( 10 ) }
        it { expect { netflix.show(title: 'The Tirmenator') }.
            to raise_error( NameError, "В базе нет такого фильма" ) }
      end

    end

    describe '#cash' do
     let(:value) {Money.new(5000, "UAH")}
     it { expect( Netflix.cash ).to eq(value) }
    end

    describe '#find_movie' do
      subject { netflix.find_movie(params) }

      context 'when movie not found' do
        let(:params) { {title: 'The Tirmenator'} }
        it { expect { netflix.show(params) }.
            to raise_error( NameError, "В базе нет такого фильма" ) }
      end

      context 'when movie find' do
        subject { netflix.find_movie(genre: 'Comedy', period: :modern) }
        it { is_expected.to be_a(TopMovies::ModernMovie) }
      end

    end

    describe '#make_payment' do
      subject { netflix }
      let(:movie) { subject.filter(title: 'The Terminator').first }

      context 'when payment successful' do
        before { subject.pay(10) }
        it { expect{ subject.make_payment(movie) }.to change(netflix, :balance).from(Money.new(1000, 'UAH')).to(Money.new(700, 'UAH'))}
      end

      context 'when balance less than cost' do
        let(:str) { /^Для просмотра.*нужно еще пополнить баланс на \d+\.\d+/ }
        it { expect{ subject.make_payment(movie)}.to raise_error( ArgumentError, str ) }
      end

    end

  end
end