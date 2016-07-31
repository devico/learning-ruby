require "rspec"
require_relative "../movie"
require_relative "../modern_movie"
require_relative "../movie_collection"
require "date"

describe '#self.create' do

#  let(:netflix) { Netflix.new("movies.txt") }
  let(:year) { 1994 }
  puts year
  let(:period) { ModernMovie if year.include?(1968..2000) }
  let(:movie_class) { period.new("http://imdb.com/title/tt0111161/?ref_=chttp_tt_1", "The Shawshank Redemption", "1994", "USA", "1994-10-14", "Crime,Drama", "142 min", "9.3", "Frank Darabont", "Tim Robbins,Morgan Freeman,Bob Gunton", movies).class }

  context 'movie_class' do
    it { is_expected.to be_a ModernMovie }
  end


end