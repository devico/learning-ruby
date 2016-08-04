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

describe Netflix do

  before { @netflix = Netflix.new("movies.txt") }

  describe '#pay' do
    subject { @netflix.pay(params) }
    context '#pay when pay 25, balance increase to 25 ' do
      let(:params){ 25 }
      let(:balance) { 25 }
      it { expect( subject ).to eq(balance) }
    end
  end

  describe '#show' do
    subject { @netflix }
    before { subject.pay(initial_balance) }
    context '#show with pay after movie is shown' do
      before { subject.show(params) }
      let(:initial_balance) { 25 }
      let(:movie) { @netflix.filter(genre: 'Comedy').first }
      let(:params) { {genre: 'Comedy', period: :modern} }
      its(:balance) { is_expected.to eq(initial_balance - movie.cost) }
    end
  end

  describe '#show with error' do
    subject { @netflix }
    before { subject.pay(initial_balance) }
    context '#show with pay after movie is shown' do
      before { subject.show(params) }
      let(:initial_balance) { 0 }
      let(:params) { {genre: 'Comedy', period: :modern} }
      it { expect { raise "Не достаточно средств для просмотра" }.to raise_error( ArgumentError, "Не достаточно средств для просмотра" ) }
    end
  end

  describe 'Netflix#film_costs' do
    subject { @netflix.film_costs(params) }
    context "#film_costs - when asked how much movie" do
      let(:movie) { @netflix.filter(title: 'The Terminator').first }
      let(:params) { {title: 'The Terminator'} }
      it { expect( subject ).to eq(movie.cost) }
    end
  end

end