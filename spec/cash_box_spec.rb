describe CashBox do

  let(:netflix) { Netflix.new("movies.txt") { include CashBox } }

  describe '#cashbox_balance' do
    subject { netflix.cashbox_balance }
    it { expect(subject).to eq(0.0) }
  end

  describe '#put_to_cashbox' do
    it { expect { netflix.pay(25) }.to change(netflix, :cashbox_balance).from(0).to(25) }
  end

end