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

  describe '#time_to_show' do
    subject { theatre.time_to_show(params) }
    context 'when time is 15:20 this is afternoon' do
      let(:params) { '15:20' }
      it { expect( subject ).to eq(:afternoon) }
    end
  end

  describe '#show' do
    subject{ theatre.show(params)}
    context 'when time is 10:20 shown movie class must be AncientMovie' do
      let(:params) { '10:20' }
      it { is_expected.to be_a AncientMovie }
    end
  end

end