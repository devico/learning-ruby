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


# describe '#show' do

#   subject { netflix.show(params) }

#     context 'send parameters' do
#       let(:netflix) { Netflix.new("movies.txt") }
#       let(:movie) { netflix.filter(genre: 'Comedy').first }
#       let(:start_time) { Time.now }
#       let(:end_time) { start_time + movie.length.to_i * 60 }
#       let(:value) { "#{movie.title} — современное кино: играют #{movie.actors.join(", ")}" }
#       let(:params){ {genre: 'Comedy', period: :modern} }
#       it { expect( subject ).to eq(value) }
#    end
# end

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
  before { subject.show(movie) }
  let(:netflix) { Netflix.new("movies.txt") }

  its(:balance) { is_expected.to eq(initial_balance - movie.cost) }
end
end

 # describe '#show with payment' do

 #  subject { netflix.show(params) }

 #    context 'when show movie balance decrease' do
 #      let(:netflix) { Netflix.new("movies.txt") }
 #      let(:balance) { netflix.pay(25).to_f }
 #      let(:movie) { netflix.filter(genre: 'Comedy').first }
 #      let(:cost)  {movie.cost}
 #      let(:value) { balance - cost }
 #      let(:params){ {genre: 'Comedy', period: :modern} }
 #      it { expect( subject ).to eq(value) }
 #   end
 # end