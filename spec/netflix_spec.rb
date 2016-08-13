describe Netflix do

  let(:netflix) { Netflix.new("movies.txt") }

  describe '#balance status' do
    subject { netflix }
    its(:balance) { is_expected.to eq(0.0) }
  end

  describe '#pay' do
    it { expect { netflix.pay(25) }.to change(netflix, :balance).from(0).to(25) }
    it { expect { netflix.pay( -2 ) }.to raise_error( ArgumentError, "Ожидается положительное число, получено -2" ) }
  end

  describe '#show' do
    subject { netflix }
    let(:movie) { subject.filter(title: 'The Sting').first }
    let(:params) { {genre: 'Comedy', period: :modern} }

    context 'when after show' do
      before { subject.pay(initial_balance) }
      before { subject.show(params) }
      let(:initial_balance) { 5 }
      its(:balance) { is_expected.to eq(initial_balance - movie.cost) }
    end

    context 'when not enough money' do
      let(:str) { sprintf("Для просмотра %s нужно еще пополнить баланс на %3.1f", movie.title, movie.cost ) }
      it { expect{ subject.show(params)}.to raise_error( ArgumentError, str ) }
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