require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"

describe '#show' do

#  let(:movies) { MovieCollection.new("movies.txt") }
  let(:netflix) { Netflix.new("movies.txt") }
  let(:movie) { netflix.all.first }
  let(:value) { "#{movie.title} — современное кино: играют #{movie.actors.join(", ")}" }

  subject { netflix.show(params) }

  context 'send parameters' do
    let(:params){ movie }
    it { expect( subject ).to eq(value) }
  end
end
