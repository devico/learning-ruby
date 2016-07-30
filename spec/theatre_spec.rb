require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../theatre"
require "date"

describe '#show' do

  let(:movies) { MovieCollection.new("movies.txt") }
  let(:movie) { movies.first }
  let(:theatre) { Theatre.new }
  let(:start_time) { Time.now }
  let(:end_time) { start_time + movie.length.to_i * 60 }
  let(:value) { "Now showing: #{movie.title} #{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")}"}

  subject { theatre.show(*params) }

  context 'send parametrs' do
      let(:params) { [movie, start_time, end_time] }
      it { expect( subject ).to eq value }
  end
end