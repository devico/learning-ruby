require 'date'

class Netflix < MovieCollection
  attr_reader :balance

  def show(params)
    movie = self.filter(params).sort_by{ |m| m.rate.to_f*rand(1000)}.last
    raise NameError, "В базе нет такого фильма" unless movie
    raise ArgumentError, "Для просмотра #{movie.title} нужно еще пополнить баланс на #{movie.cost-@balance}" if @balance < movie.cost
    @balance -= movie.cost
    if movie.kind_of?(ClassicMovie)
      movie.show + ", кроме этого еще #{self.filter(author: movie.author).length} фильмa(ов) #{movie.author} вошли в ТОП-250"
    else
      movie.show
    end

  end

  def pay(payment)
    raise ArgumentError, "Ожидается положительное число, получено #{payment}" if payment <= 0
    @balance += payment
  end

  def film_costs(movie)
    movie = self.filter(movie).first
    raise NameError, "В базе нет такого фильма" unless movie
    movie.cost
  end

end