require "rspec"
require_relative "../movie"
require_relative "../ancient_movie"
require_relative "../classic_movie"
require_relative "../modern_movie"
require_relative "../new_movie"
require_relative "../movie_collection"
require_relative "../netflix"
require "date"


describe '#show' do

  subject { netflix.show(params) }

    context 'send parameters' do
      let(:netflix) { Netflix.new("movies.txt") }
      let(:movie) { netflix.filter(genre: 'Comedy').first }
      let(:start_time) { Time.now }
      let(:end_time) { start_time + movie.length.to_i * 60 }
#      let(:value) { "Now showing: #{movie.title} #{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")}" }
      let(:value) { "#{movie.title} — современное кино: играют #{movie.actors.join(", ")}" }
      let(:params){ {genre: 'Comedy', period: :modern} }
      it { expect( subject ).to eq(value) }
   end
 end
