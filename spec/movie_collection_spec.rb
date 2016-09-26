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

    describe '#get_budget' do
      it "given a budget" do
        VCR.use_cassette('imdb/budget') do
          stub_request(:get, "http://imdb.com/title/tt0103064/?ref_=chttp_tt_41").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => "", :headers => {})
          page = Nokogiri::HTML(open("http://imdb.com/title/tt0103064/?ref_=chttp_tt_41"))
          expect(page.class).to eq(Nokogiri::HTML::Document)
        end
      end
    end

  end
end