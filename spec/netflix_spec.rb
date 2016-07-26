require "rspec"
require_relative "../movie"
require_relative "../movie_collection"
require_relative "../netflix"

describe Netflix do

  it "add movie to show" do
    netflix = Netflix.new
    expect(netflix.show).to eq("Now showing:")
  end

end