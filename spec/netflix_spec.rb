describe Netflix do

  let(:netflix) { Netflix.new("movies.txt") }

  describe '#balance status' do
    subject { netflix }
    context "when creare object" do
     its(:balance) { is_expected.to eq(0.0) }
    end
  end

  describe '#pay' do

    context 'when pay 25' do
      it { expect( netflix.pay(25) ).to change { netflix.balance } }
    end

    context 'when pay 0 or negative value' do
      it { expect { netflix.pay( -2 ) }.
        to raise_error( ArgumentError, "Ожидается положительное число, получено -2" ) }
    end
  end

  describe '#show' do
    subject { netflix }

    context 'when after show' do
      before { subject.pay(initial_balance) }
      before { subject.show(params) }
      let(:initial_balance) { 5 }
      let(:movie) { netflix.filter(genre: 'Comedy').first }
      let(:params) { {genre: 'Comedy', period: :modern} }
      its(:balance) { is_expected.to eq(initial_balance - movie.cost) }
    end

    context 'when not enough money' do
      it { expect { subject.show(genre: 'Comedy', period: :modern) }.
          to raise_error( ArgumentError, "Для просмотра Title нужно еще пополнить баланс на #{movie.cost - @balance}" ) }
    end

    context 'when not have movie in base' do
      before { subject.pay( 10.0 ) }
      it { expect { subject.show(title: 'The Tirmenator') }.
          to raise_error( NameError, "В базе нет такого фильма" ) }
    end

  end

  describe '#film_costs' do

    context "when send title" do
      subject { netflix.film_costs(params) }
      let(:movie) { netflix.filter(title: 'The Terminator').first }
      let(:params) { {title: 'The Terminator'} }
      it { expect( subject ).to eq(movie.cost) }
    end

    context 'when not have movie in base' do
      before { netflix.pay( 10.0 ) }
      it { expect { netflix.show(title: 'The Tirmenator') }.
          to raise_error( NameError, "В базе нет такого фильма" ) }
    end

  end

end