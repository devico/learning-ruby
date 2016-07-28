require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"

describe '#show' do

  let(:movies) { MovieCollection.new("movies.txt") }
  let(:movie) { movies.first }
  let(:netflix) { Netflix.new }
  let(:start_time) { Time.now }
  let(:end_time) { start_time + movie.length.to_i * 60 }
  let(:value) { "Now showing: #{movie.title} #{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")}"}

  subject { netflix.show(*params) }

  context 'send parametrs' do
      let(:params) { [movie, start_time, end_time] }
      it { expect( subject ).to eq value }
  end
end
