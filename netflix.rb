require 'date'

class Netflix < MovieCollection

  def initialize

  end

  def show(movie, period)
    time_now = Time.now
    "#{movie.title} — старый фильм (#{movie.year} год)" if period == :AncientMovie
    "#{movie.title} — классический фильм, режиссёр #{movie.author}" if period == :ClassicMovie
    "#{movie.title} — современное кино: играют #{movie.actors.join(", ")}" if period == :ModernMovie
    "#{movie.title} — новинка, вышло #{time_now.year - movie.year} лет назад!" if period == :NewMovie

  end

end