describe CashBox do

  describe '#cashbox_balance' do
    let(:netflix) { Netflix.new("movies.txt") { include CashBox } }
    subject { netflix.cashbox_balance }
    its(:cashbox_balance) { is_expected.to eq(0.0) }
  end

end