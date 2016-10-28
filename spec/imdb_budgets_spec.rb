module TopMovies

  describe ImdbBudgets do

    let(:movies) { TopMovies::MovieCollection.new(DEFAULT_MOVIES_PATH) { include ImdbBudgets } }

    describe '#take_budget_from_file' do
      subject { movie.take_budget_from_file(file) }
      let(:movie) { movies.all.first }
      let(:file) { "#{movie.imdb_id}.yml" }
      it 'when take budget from file' do
        expect(subject).to eq("$25,000,000")
      end
    end

    describe '#take_budget_from_imdb' do
      subject { movie.take_budget_from_imdb(movie.imdb_id) }
      let(:movie) { movies.all[120] }
      it 'when take budget from IMDB' do
        VCR.use_cassette('imdb/budget_imdb') do
          allow(File).to receive(:exists?).with("#{movie.imdb_id}.yml").and_return(true)
        end
      end
    end

    describe '#take_info' do
      let(:movie) { movies.all[151] }
      it 'when recieve info about movie' do
        VCR.use_cassette('imdb/budget') do
          expect(movie.take_info).to eq("$3,977,000")
        end
      end
    end
  end
end