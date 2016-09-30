module TopMovies

  describe ImdbBudgets do

    let(:movies) { TopMovies::MovieCollection.new("movies.txt") { include ImdbBudgets } }

    describe '#take_budget' do

    end

    describe '#obtain_pages' do
      it "given a pages" do
        VCR.use_cassette('imdb/pages') do
          page = Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
          expect(page.class).to eq(Nokogiri::HTML::Document)
        end
      end
    end

    describe '#take_info' do
      let(:pages) { [] }
      let(:value) { ["tt0111161", "$25,000,000"] }
      it 'when recieve info about movie' do
        VCR.use_cassette('imdb/budget') do
          pages << Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
          expect(movies.take_info(pages).first).to eq(value)
        end
      end
    end

    describe '#info_to_yml' do
      let(:pages) { [] }
      let(:value) { ["---\nimdb_id: tt0111161\nbudget: \"$25,000,000\"\n"] }
      it 'when save info to file' do
        VCR.use_cassette('imdb/saved_info') do
          pages << Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
          info = movies.take_info(pages)
          expect(movies.info_to_yml(info)).to eq(value)
        end
      end
    end

  end
end