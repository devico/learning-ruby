describe CashBox do

  let(:netflix) { Netflix.new("movies.txt") { include CashBox } }

  describe '#cashbox_balance' do
    subject { netflix.cashbox_balance }
    it { expect(subject).to eq(0.0) }
  end

  describe '#put_to_cashbox' do
    it { expect { netflix.pay(5) }.to change(netflix, :cashbox_balance).from(0).to(5) }

    context 'when Netflix.cash' do
      before { netflix.pay(25) }
      it { expect( Netflix.cash ).to eq(30) }
    end

  end

  describe '#take' do

    context 'when Bank' do
      it { expect( netflix.take('Bank') ).to eq(0.0) }
    end

    context 'when not Bank' do
      it { expect{netflix.take('No Bank') }.to raise_error( ArgumentError, "Нарушение безопасности, вызвана полиция" ) }
    end

  end

end