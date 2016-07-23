require_relative 'movie'
require 'csv'

class MovieCollection
  attr_accessor :collection

  def initialize(file_name)
    @collection =  CSV.read(file_name, col_sep: '|', headers: %i[ link title year country date genre length rate author actors ] )
    .map { |film| film.to_hash }
    .map { |film| Movie.new(film[:link], film[:title], film[:year], film[:country], film[:date], film[:genre], film[:length], film[:rate], film[:author], film[:actors], self) }
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
    filters.reduce (@collection){ |filtered, (name, value) | filtered.select{ |f| f.match?(name, value) }.map { |m| puts "#{m.title} - #{m.send(name)}"} }

  end

#выводить статистику по запроcу: режиссер, актер, год, месяц, страна, жанр
  def stats(movie_field)
    @collection.map(&movie_field).flatten.group_by(&:itself).map{ |k, v|  [k, v.count] }.sort.to_h
  end

  def genre_exists?(genre_film)
    @genres ||= @collection.map { |f| f.genre }.flatten.uniq
    @genres.include?(genre_film)
  end

end
