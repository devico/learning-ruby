require "rspec"
require_relative "../movie"
require_relative "../modern_movie"
require_relative "../movie_collection"
require "date"

describe '#self.create' do

  let(:movies) { MovieCollection.new("movies.txt") }
  let(:modern_movie) { ModernMovie.new("http://imdb.com/title/tt0111161/?ref_=chttp_tt_1",
    "The Shawshank Redemption", "1994", "USA", "1994-10-14", "Crime,Drama", "142 min", "9.3",
    "Frank Darabont", "Tim Robbins,Morgan Freeman,Bob Gunton", movies) }

  subject { Movie.create(*params) }

  context 'verify movie class' do
    let(:params) {[]}
    it { expect( subject ).to eq(modern_movie.class) }
  end


end