require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"

describe Netflix do

  it "add movie to show" do
    movies = MovieCollection.new("movies.txt")
    movie = movies.all.first
    netflix = Netflix.new
    t0 = Time.now
    t1 = t0 + movie.length.to_i * 60
    expect(netflix.show(movie.title, t0, t1)).to eq("Now showing: The Shawshank Redemption #{t0.strftime("%H:%M")} - #{t1.strftime("%H:%M")}")
  end

end