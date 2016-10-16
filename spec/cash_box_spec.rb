module TopMovies

  describe CashBox do

    let(:netflix) { TopMovies::Netflix.new("lib/topmovies/data/movies.txt") { include CashBox } }
    let(:value) { Money.new(0, "UAH") }


    describe '#cashbox_balance' do
      subject { netflix.cashbox_balance }
      it { expect(subject).to eq(Money.new(0, "UAH")) }
    end

    describe '#put_to_cashbox' do
      it { expect { netflix.pay(5) }.to change(netflix, :cashbox_balance).from(Money.new(0, "UAH")).to(Money.new(500, "UAH")) }
    end

    describe '#take' do

      context 'when Bank' do
        it { expect( netflix.take('Bank') ).to eq(Money.new(0, "UAH")) }
      end

      context 'when not Bank' do
        it { expect{netflix.take('No Bank') }.to raise_error( ArgumentError, "Нарушение безопасности, вызвана полиция" ) }
      end

    end

  end

end