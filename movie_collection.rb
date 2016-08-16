require 'csv'
require_relative 'cash_box'

class MovieCollection

  include Enumerable
  include CashBox

  attr_accessor :collection

  def initialize(file_name)
    @collection =  CSV.read(file_name, col_sep: '|', headers: %i[ link title year country date genre length rate author actors ] )
    .map { |film| film.to_hash }
    .map { |film| Movie.create(film[:link], film[:title], film[:year], film[:country], film[:date], film[:genre], film[:length], film[:rate], film[:author], film[:actors], self) }

    @balance = 0.0
    @cashbox_balance = 0.0
  end


# выводить список всех файлов
def all
  @collection
end

def first
 @collection.first
end

  #выдать сортированный список фильмов для любого поля
  def sort_by(filter)
    @collection
      .sort_by(&filter)
      .map { |c| puts "#{c.title.to_s} - #{c.send(filter)}" }
  end

#выдать фильтрованный список фильмов — по полям: жанра и страны
  def filter(filters)
      filters.reduce (@collection){ |filtered, (name, value) | filtered.select{ |f| f.match?(name, value) } }
  end

#выводить статистику по запроcу: режиссер, актер, год, месяц, страна, жанр
  def stats(movie_field)
    @collection.map(&movie_field).flatten.group_by(&:itself).map{ |k, v|  [k, v.count] }.sort.to_h
  end

  def genre_exists?(genre_film)
    @genres ||= @collection.map { |f| f.genre }.flatten.uniq
    @genres.include?(genre_film)
  end

  def cash
    cashbox_state
  end

end
