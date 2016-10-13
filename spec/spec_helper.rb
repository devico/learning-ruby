require 'rspec/its'
require_relative "../lib/topmovies/movie"
require_relative "../lib/topmovies/ancient_movie"
require_relative "../lib/topmovies/classic_movie"
require_relative "../lib/topmovies/modern_movie"
require_relative "../lib/topmovies/new_movie"
require_relative "../lib/topmovies/movie_collection"
require_relative "../lib/topmovies/netflix"
require_relative "../lib/topmovies/theatre"
require 'haml'
require "date"
require "money"
require 'vcr'
require 'themoviedb'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end