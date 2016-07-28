require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"

describe '#show' do

  let(:movies) { MovieCollection.new("movies.txt") }
  let(:movie) { movies.first }
  let(:period) {movie.period?}
  let(:netflix) { Netflix.new }
#  let(:start_time) { Time.now }
#  let(:end_time) { start_time + movie.length.to_i * 60 }
  let(:value) { "#{movie.title} — современное кино: играют #{movie.actors.join(", ")}" }

  subject { netflix.show(*params) }

  context 'send parameters' do
      let(:params) { [movie, period] }
      it { expect( subject ).to eq value }
  end
end
