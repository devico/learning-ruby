module TopMovies

  describe MovieCollection do

    describe '#by_genre' do
      before { TopMovies::MovieCollection.send(:define_method, 'comedy') { filter(genre: 'Comedy') } }
      let(:collection) { TopMovies::MovieCollection.new('movies.txt') }
      subject { collection.by_genre }
      it 'allows to filter the collection' do
        expect(subject.comedy).to eq collection.filter(genre: 'Comedy')
      end
    end

  end
end