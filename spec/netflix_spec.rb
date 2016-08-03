require "rspec"
require "spec_helper"
require_relative "../movie"
require_relative "../ancient_movie"
require_relative "../classic_movie"
require_relative "../modern_movie"
require_relative "../new_movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"

describe '#pay' do

  subject { netflix.pay(params) }

    context 'when pay 25, balance increase to 25 ' do
      let(:netflix) { Netflix.new("movies.txt") }
      let(:params){ 25 }
      let(:balance) { 25 }
      it { expect( subject ).to eq(balance) }
   end
 end

describe '#show with payment' do

  subject { netflix }
  before { subject.pay(initial_balance) }
  context 'after movie is shown' do
    before { subject.show(params) }
    let(:netflix) { Netflix.new("movies.txt") }
    let(:initial_balance) { 25 }
    let(:movie) { netflix.filter(genre: 'Comedy').first }
    let(:params) { {genre: 'Comedy', period: :modern} }
    its(:balance) { is_expected.to eq(initial_balance - movie.cost) }
  end
end
