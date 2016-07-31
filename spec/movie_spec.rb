require "rspec"
require_relative "../movie"
require_relative "../modern_movie"
require_relative "../ancient_movie"
require_relative "../classic_movie"
require_relative "../new_movie"

describe '#self.create' do

  subject { Movie.create(*params) }

  context 'when year is 1900-1945' do
    let(:year) { 1926 }
    let(:params) { ["http://imdb.com/title/tt0017925/?ref_=chttp_tt_136", "The General", year, "USA", "1927-02-24", "Action,Adventure,Comedy", "67 min", "8.3", "Clyde Bruckman", "Buster Keaton,Marion Mack,Glen Cavender", self] }
    it { is_expected.to be_a AncientMovie }
  end

  context 'when year is 1945-1968' do
    let(:year) { 1962 }
    let(:params) { ["http://imdb.com/title/tt0056592/?ref_=chttp_tt_84", "To Kill a Mockingbird", year, "USA", "1963-03-16", "Drama", "129 min", "8.4", "Robert Mulligan", "Gregory Peck,John Megna,Frank Overton", self] }
    it { is_expected.to be_a ClassicMovie }
  end

  context 'when year is 1968-2000' do
    let(:year) { 1994 }
    let(:params) { ["http://imdb.com/title/tt0111161/?ref_=chttp_tt_1", "The Shawshank Redemption", year, "USA", "1994-10-14", "Crime,Drama", "142 min", "9.3", "Frank Darabont", "Tim Robbins,Morgan Freeman,Bob Gunton", self] }
    it { is_expected.to be_a ModernMovie }
  end

  context 'when year is over 2000' do
    let(:year) { 2003 }
    let(:params) { ["http://imdb.com/title/tt0167260/?ref_=chttp_tt_9", "The Lord of the Rings: The Return of the King", year, "USA", "2003-12-17", "Adventure,Fantasy", "201 min", "8.9", "Peter Jackson", "Elijah Wood, Viggo Mortensen,Ian McKellen", self] }
    it { is_expected.to be_a NewMovie }
  end

end