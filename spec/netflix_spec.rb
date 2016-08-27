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

    describe '#show' do
      subject { netflix }
      let(:movie) { subject.filter(genre: 'Comedy').first }
      let(:params) { {genre: 'Comedy', period: :modern} }

      context 'when after show' do
        before { subject.pay(initial_balance) }
        before { subject.show(params) }
        let(:params) { {genre: 'Comedy', period: :modern} }
        let(:initial_balance) { 5 }
        its(:balance) { is_expected.to eq( Money.new((initial_balance - movie.cost)*100, "UAH" ) ) }
      end

      context 'when not enough money' do
        before { netflix.pay( 10 ) }
        subject { netflix.show(params) }
        let(:params) { {genre: 'Comedy', period: :modern} }
        let(:str) { /(.*)современное кино: играют(.*)/ }
        it { expect(subject).to match(str) }
      end

      context 'when not have movie in base' do
        before { subject.pay( 10.0 ) }
        let(:params) { {title: 'The Tirmenator'} }
        it { expect { netflix.show(params) }.
          to raise_error( NameError, "В базе нет такого фильма" ) }
      end

    end

    describe '#filter_movie' do
      subject { movies.sort_by { |m| m.rate.to_f * rand(1000) }.last }
      let(:movies) { netflix.all.select { |m| blok.call(m) } }
      let(:filters) { {genre: 'Comedy', period: :modern} }
      let(:blok) { Proc.new { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} }
      it { is_expected.to be_a TopMovies::NewMovie }
    end

    describe '#find_by_block' do
      before { netflix.pay( 10 ) }
      subject { movies.first }
      let(:blok) { Proc.new { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} }
      let(:movies) { netflix.all.select { |m| blok.call(m) } }
      it { is_expected.to be_a TopMovies::NewMovie }
    end

    describe 'find_by_custom_filters' do
      before { netflix.pay( 10 ) }
      before { netflix.define_filter(:new_sci_fi) { |movie| movie.genre.include?('Sci-Fi') && !movie.author.include?('Steven Spielberg') && !movie.country.include?('UK') } }
      subject { movie.genre }
      let(:first_blok) { Proc.new { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} }
      let(:films) { netflix.all.select { |m| first_blok.call(m) } }
      let(:blok) { Proc.new { |movie| movie.genre.include?('Sci-Fi') && !movie.author.include?('Steven Spielberg') && !movie.country.include?('UK') } }
      let(:movies) { films.select { |m| blok.call(m) } }
      let(:movie) { movies.first }
      let(:value) { 'Sci-Fi' }
      it { expect(subject).to include(value) }
    end

    describe '#find_by_inner_filters' do
      before { netflix.pay( 10 ) }
      subject { netflix.show(params) }
      let(:params) { {genre: 'Comedy', period: :modern} }
      let(:str) { /.*современное кино: играют.*/ }
      it { expect(subject).to match(str) }
    end

    describe 'define_filter' do
      subject { filter }
      let(:filter) { {filter_name => blok} }
      let(:filter_name) { :new_sci_fi }
      let(:blok) { Proc.new { |movie| movie.genre.include?('Sci-Fi') && !movie.author.include?('Steven Spielberg') && !movie.country.include?('UK') } }
      it { is_expected.to be_a Hash }
    end

    describe '#film_costs' do

      context "when send title" do
        subject { netflix.film_costs(params) }
        let(:movie) { netflix.filter(title: 'The Terminator').first }
        let(:params) { {title: 'The Terminator'} }
        it { expect( subject ).to eq(Money.new(movie.cost*100, "UAH")) }
      end

      context 'when not have movie in base' do
        before { netflix.pay( 10 ) }
        it { expect { netflix.show(title: 'The Tirmenator') }.
            to raise_error( NameError, "В базе нет такого фильма" ) }
      end

    end

    describe '#cash' do
     let(:value) {Money.new(9000, "UAH")}
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