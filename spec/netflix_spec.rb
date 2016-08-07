describe Netflix do

  let(:netflix) { Netflix.new("movies.txt") }

  describe '#balance status' do
    subject { netflix }
    context "initital balance" do
     its(:balance) { is_expected.to eq(0.0) }
    end
  end

  describe '#pay' do

    context 'when pay 25, balance increase to 25 ' do
      subject { netflix.pay(params) }
      let(:params){ 25 }
      it { expect( subject ).to eq(25) }
    end

    context 'when pay 0 or negative value show exception' do
      it { expect { netflix.pay( -2 ) }.
        to raise_error( ArgumentError, "Ожидается положительное число, получено -2" ) }
    end
  end

  describe '#show' do
    subject { netflix }

    context 'when balance decrease after show movie' do
      before { subject.pay(initial_balance) }
      before { subject.show(params) }
      let(:initial_balance) { 5 }
      let(:movie) { netflix.filter(genre: 'Comedy').first }
      let(:params) { {genre: 'Comedy', period: :modern} }
      its(:balance) { is_expected.to eq(initial_balance - movie.cost) }
    end

    context 'when negative balance for show movie' do
      it { expect { subject.show(genre: 'Comedy', period: :modern) }.
          to raise_error( ArgumentError, "Не достаточно средств для просмотра" ) }
    end

    context 'when not have movie in base' do
      before { subject.pay( 10.0 ) }
      it { expect { subject.show(title: 'The Tirmenator') }.
          to raise_error( NameError, "В базе нет такого фильма" ) }
    end

  end

  describe '#film_costs' do


    context "when asked how much cost movie" do
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