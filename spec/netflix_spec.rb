module TopMovies

  describe Netflix do

    let(:netflix) { TopMovies::Netflix.new("movies.txt") }

    describe '#balance status' do
      subject { netflix }
      its(:balance) { is_expected.to eq(0.0) }
    end

    describe '#pay' do
      it { expect { netflix.pay(25) }.to change(netflix, :balance).from(0).to(Money.new(2500, "UAH")) }
      it { expect { netflix.pay( -2 ) }.to raise_error( ArgumentError, "Ожидается положительное число, получено -2.00" ) }
    end

    describe '#show_with_filters_blocks' do

      before { netflix.pay(10) }

      describe '#show' do
        subject { netflix }
        let(:movie) { subject.filter({genre: 'Comedy', period: :modern}).first }
        let(:params) { {genre: 'Comedy', period: :modern} }

        context 'when not enough money' do
          subject { netflix.show(params) }
          let(:params) { {genre: 'Comedy', period: :modern} }
          let(:str) { /(.*)— современное кино: играют(.*)/ }
          it { expect(subject).to match(str) }
        end
      end

      describe '#filter_movie' do

        context 'when filter_movie return movie' do
          subject { movies.sort_by { |m| m.rate.to_f * rand(1000) }.last }
          let(:movies) { netflix.all.select(&blok) }
          let(:filters) { {genre: 'Comedy', period: :modern} }
          let(:blok) { Proc.new { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} }
          it { is_expected.to be_a TopMovies::NewMovie }
        end

      end

      describe '#find_by_block' do
        subject { netflix.find_by_block(netflix.all, &blok).first }
        let(:blok) { Proc.new { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} }
        its(:title) { is_expected.not_to eq('Terminator') }
        its(:genre) { is_expected.to include('Action') }
        its(:year) { is_expected.to be > 2003 }
      end

      describe 'find_by_custom_filters' do

        context 'when filter without params' do
          before { netflix.define_filter(:new_sci_fi) { |movie| movie.genre.include?('Sci-Fi') && !movie.author.include?('Steven Spielberg') && !movie.country.include?('UK') } }
          subject { netflix.find_by_custom_filters(films, filters).first }
          let(:films) { netflix.all.select(&first_blok) }
          let(:filters) { {new_sci_fi: true} }
          let(:first_blok) { Proc.new { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} }
          let(:blok) { Proc.new { |movie| movie.genre.include?('Sci-Fi') && !movie.author.include?('Steven Spielberg') && !movie.country.include?('UK') } }
          its(:genre) { is_expected.to include('Sci-Fi') }
          its(:author) { is_expected.not_to eq('Steven Spielberg') }
          its(:country) { is_expected.not_to eq('UK') }
        end

        context 'when filter with params' do
          before { netflix.define_filter(:new_sci_fi) { |movie, year| movie.year > year } }
          subject { netflix.find_by_custom_filters(netflix.all, filters).first }
          let(:filters) { {new_sci_fi: 2010} }
          its(:year) { is_expected.to be > 2010 }
        end

      end

      describe '#find_by_inner_filters' do
        before { netflix.define_filter(:new_sci_fi) { |movie| movie.genre.include?('Sci-Fi') && !movie.author.include?('Steven Spielberg') && !movie.country.include?('UK') } }
        subject { netflix.find_by_inner_filters(films_from_custom, filters).first }
        let(:films_from_blok) { netflix.find_by_block(netflix.all, &blok) }
        let(:films_from_custom) { netflix.find_by_custom_filters(films_from_blok, filters) }
        let(:blok) { Proc.new { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} }
        let(:filters) { {new_sci_fi: true} }
        its(:genre) { is_expected.to include('Mystery') }
        its(:period){ is_expected.to eq(:"topmovies::new") }
      end

      describe 'define_filter' do
        subject { filter }
        let(:filter) { {filter_name => blok} }

        context 'custom filter no params' do
          let(:filter_name) { :new_sci_fi }
          let(:blok) { Proc.new { |movie| movie.genre.include?('Sci-Fi') && !movie.author.include?('Steven Spielberg') && !movie.country.include?('UK') } }
          it { is_expected.to be_a Hash }
        end

        context 'custom filter with params' do
          let(:filter_name) { {new_sci_fi: 2010} }
          let(:blok) { Proc.new { |movie, year| movie.year > year } }
          it { is_expected.to be_a Hash }
        end

        context 'user filter' do
          before { netflix.define_filter(:new_sci_fi) { |movie, year| movie.year > year } }
          let(:filter_name) { :newest_sci_fi }
          let(:blok) { netflix.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014) }
          it { is_expected.to be_a Hash }
        end

      end

      context 'several filters' do
        before { netflix.define_filter(:new_sci_fi) { |movie| movie.genre.include?('Sci-Fi') && !movie.country.include?('UK') } }
        before { netflix.define_filter(:not_spielberg) { |movie| !movie.author.include?('Steven Spielberg') } }
        subject { netflix.find_by_custom_filters(netflix.all, filters).first }
        let(:filters) { {new_sci_fi: true, not_spielberg: true} }
        its(:genre) { is_expected.to include('Sci-Fi') }
        its(:author) { is_expected.not_to include('Steven Spielberg') }
      end

      context 'several filters' do
        before { netflix.define_filter(:new_sci_fi) { |movie| movie.genre.include?('Sci-Fi') && !movie.country.include?('UK') } }
        before { netflix.define_filter(:not_spielberg) { |movie| !movie.author.include?('Steven Spielberg') } }
        subject { netflix.find_by_custom_filters(netflix.all, filters).first }
        let(:filters) { {new_sci_fi: true, not_spielberg: true} }
        its(:genre) { is_expected.to include('Sci-Fi') }
        its(:author) { is_expected.not_to include('Steven Spielberg') }
      end

    end

    describe '#film_costs' do

        subject { netflix.film_costs(params) }
        let(:movie) { netflix.filter(title: 'The Terminator').first }
        let(:params) { {title: 'The Terminator'} }
        it { expect( subject ).to eq(Money.new(movie.cost*100, "UAH")) }
    end

    describe '#cash' do
     let(:value) {Money.new(21000, "UAH")}
     it { expect( Netflix.cash ).to eq(value) }
    end

    describe '#make_payment' do
      subject { netflix }
      let(:movie) { subject.filter(title: 'The Terminator').first }

      context 'when payment successful' do
        before { subject.pay(10) }
        it { expect{ subject.make_payment(movie) }.to change(netflix, :balance).from(Money.new(1000, 'UAH')).to(Money.new(700, 'UAH'))}
      end

      context 'when balance less than cost' do
        let(:str) { /^Для просмотра.*нужно еще пополнить баланс на \d+\.\d+/ }
        it { expect{ subject.make_payment(movie)}.to raise_error( ArgumentError, str ) }
      end

    end
  end

end