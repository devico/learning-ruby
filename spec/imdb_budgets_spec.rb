module TopMovies

  describe ImdbBudgets do

    let(:movies) { TopMovies::MovieCollection.new("movies.txt") { include ImdbBudgets } }

    describe '#take_budget' do

    end

    describe '#obtain_pages' do
      it "given a pages" do
        VCR.use_cassette('imdb/pages') do
          stub_request(:get, "http://imdb.com/title/tt0111161/?ref_=chttp_tt_41").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => "", :headers => {})
          page = Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
          expect(page.class).to eq(Nokogiri::HTML::Document)
          expect(page.css('div.txt-block:nth-child(11)').map { |el| el.text.split(' ')[1] }).to be_a Array
        end
      end
    end

    describe '#take_info' do
      it 'when recieve info about movie' do
        stub_request(:get, "http://imdb.com/title/tt0111161/?ref_=chttp_tt_41").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})
        page = Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
        expect(movies.take_info(page)).to be_a Array
      end
    end

    describe '#info_to_yml' do
      it 'when save info to file' do
        stub_request(:get, "http://imdb.com/title/tt0111161/?ref_=chttp_tt_41").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})
        page = Nokogiri::HTML(open("http://imdb.com/title/tt0111161/?ref_=chttp_tt_41"))
        info = movies.take_info(page)
        expect(movies.info_to_yml(info)).to be_a Array
      end
    end

  end
end