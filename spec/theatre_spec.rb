require "rspec"
require 'spec_helper'
require_relative "../movie"
require_relative "../ancient_movie"
require_relative "../classic_movie"
require_relative "../modern_movie"
require_relative "../new_movie"
require_relative "../movie_collection"
require_relative "../theatre"
require "date"

describe Theatre do

  let(:theatre) { Theatre.new("movies.txt")}

  describe "#time_of_day?" do
    subject { theatre.time_of_day?(params) }
    context 'send parametrs' do
      let(:value) { :afternoon }
      let(:params) { '15:20' }
      it { expect( subject ).to eq(value) }
    end
  end

  describe "when show movie" do
    subject{ theatre.show(params)}
    context "show movie for this time" do
      let(:params) { '10:20' }
      it { is_expected.to be_a AncientMovie }
    end
  end

end