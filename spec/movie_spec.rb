require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require "date"

describe '#afisha' do

  let(:movies) { MovieCollection.new("movies.txt") }
  let(:movie) { movies.first }
  let(:period) { (1968...2000) }
  let(:value) { "#{movie.title} — современное кино: играют #{movie.actors.join(", ")}" }

  subject { movie.afisha }

  context 'verify params' do
    it { expect( period ).to include(movie.year) }
  end

  context 'verify #afisha' do
    it { expect( subject ).to eq(value) }
  end


end