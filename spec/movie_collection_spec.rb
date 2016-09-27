module TopMovies

  describe MovieCollection do
    let(:collection) { TopMovies::MovieCollection.new('movies.txt') }

    describe '#by_genre' do
      before { TopMovies::MovieCollection.send(:define_method, 'comedy') { filter(genre: 'Comedy') } }
      subject { collection.by_genre }
      it 'allows to filter the collection' do
        expect(subject.comedy).to eq collection.filter(genre: 'Comedy')
      end
    end

  end
end