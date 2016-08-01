require "rspec"
require_relative "../movie"
require_relative "../ancient_movie"
require_relative "../classic_movie"
require_relative "../modern_movie"
require_relative "../new_movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"


# describe '#show' do

#   let(:netflix) { Netflix.new("movies.txt") }
#   let(:movie) { netflix.all.first }
#   let(:value) { "#{movie.title} — современное кино: играют #{movie.actors.join(", ")}" }

#   subject { netflix.show(params) }

#   context 'send parameters' do
#     let(:params){ [genre: 'Comedy', period: :modern] }
#     it { expect( subject ).to eq(value) }
#   end
# end

describe '#pay' do

  let(:netflix) { Netflix.new("movies.txt") }
  let(:params) { 25 }

  subject { netflix.pay(params) }

  context 'when send pay, balance equal 25' do
    it { expect( subject ).to eq 25 }
  end

end
