module TopMovies

  describe ImdbBudgets do

    let(:movies) { TopMovies::MovieCollection.new("movies.txt") { include ImdbBudgets } }

    describe '#take_budget_from_file' do
      subject { movie.take_budget_from_file(file) }
      let(:movie) { movies.all.first }
      let(:file) { "#{movie.imdb_id}.yml" }
      it 'when take budget from file' do
        expect(subject).to eq("$25,000,000")
      end
    end

    describe '#take_budget_from_imdb' do
      subject { movie.take_budget_from_imdb(movie.imdb_id)[0][0] }
      let(:movie) { movies.all[120] }
      it 'when take budget from IMDB' do
        VCR.use_cassette('imdb/budget_imdb') do
          expect(subject).to eq("$28,000,000")
        end
      end
    end

    describe '#take_info' do
      let(:movie) { movies.all[151] }
      let(:value) { "---\nimdb_id: tt0031381\nbudget: \"$3,977,000\"\n" }
      it 'when recieve info about movie' do
        VCR.use_cassette('imdb/budget') do
          expect(movie.take_info).to eq(value)
        end
      end
    end
  end
end