require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"

describe '#show' do

  let(:movies) { MovieCollection.new("movies.txt") }
  let(:movie) { movies.first }
  let(:netflix) { Netflix.new }
  let(:t0) { Time.now }
  let(:t1) { t0 + movie.length.to_i * 60 }
  let(:value) { "Now showing: "}

  subject { netflix.show(params) }

  context 'send prms' do
      let(:params) { [:movie, :t0, :t1] }
      it { expect { subject }.to equal(value) }
  end
end
