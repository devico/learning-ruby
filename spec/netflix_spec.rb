require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../netflix"

describe Netflix do

  it "add movie to show" do
    movies = MovieCollection.new("movies.txt")
    movie = movies.all.first
    netflix = Netflix.new
    expect(netflix.show(movie.title)).to eq("Now showing: The Shawshank Redemption")
  end

end