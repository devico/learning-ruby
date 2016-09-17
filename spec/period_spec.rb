module TopMovies

  describe 'Period' do

    let(:theatre) do
        TopMovies::Theatre.new do
          hall :red, title: 'Красный зал', places: 100
          hall :blue, title: 'Синий зал', places: 50
          hall :green, title: 'Зелёный зал (deluxe)', places: 12

          period '09:00'..'12:00' do
            description 'Утренний сеанс'
            filters genre: 'Comedy', year: 1900..1980
            price 10
            hall :red, :blue
          end
        end
      end

    describe '#initialize' do
      subject { theatre.periods[0] }
      it { is_expected.to be_a TopMovies::Period }
    end

    describe '#intersect?' do

      subject { theatre.periods[0].intersect?(new_period[0]) }
      let(:new_period) { theatre.period(name, &block) }

      context 'when added period not intersect' do
        let(:name) { '13:00'..'15:00' }
        let(:block) do
          Proc.new do
            description 'Второй сеанс'
            filters genre: 'Comedy'
            price 13
            hall :red
          end
        end
        it { expect(subject).to be_truthy }
      end

      context 'when added period intersect and halls not match' do
        let(:name) { '10:00'..'11:00' }
        let(:block) do
          Proc.new do
            description 'Второй сеанс'
            filters genre: 'Comedy'
            price 13
            hall :green
          end
        end
        it { expect(subject).to be_truthy }
      end
    end
  end
end