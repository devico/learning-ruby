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

    describe '#create_yml' do
      let(:movie) { movies.all[120] }
      it 'when create yml file' do
        allow(File).to receive(:exists?).with("#{movie.imdb_id}.yml").and_return(true)
      end
    end

    describe '#take_info' do
      let(:value) { ["tt0111161", "$25,000,000"] }
      it 'when recieve info about movie' do
        VCR.use_cassette('imdb/budget') do
          page = Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
          expect(movies.take_info(page)).to eq(value)
        end
      end
    end

    describe '#info_to_yml' do
      let(:value) { "---\nimdb_id: tt0111161\nbudget: \"$25,000,000\"\n" }
      it 'when convert info to yml format' do
        VCR.use_cassette('imdb/saved_info') do
          page = Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
          info = movies.take_info(page)
          expect(movies.info_to_yml(info)).to eq(value)
        end
      end
    end

    describe '#put_to_file' do
      it 'when save info to file' do
        file = double("budget.yml")
        expect(file).to receive(:write).with("---\nimdb_id: tt0111161\nbudget: \"$25,000,000\"\n").at_most(:once)
      end
    end

  end
end