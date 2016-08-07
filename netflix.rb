require 'date'

class Netflix < MovieCollection
  attr_reader :balance

  def show(params)
    movie = self.filter(params).first
    raise NameError, "В базе нет такого фильма" unless movie
    raise ArgumentError, "Для просмотра #{movie.title} нужно еще пополнить баланс на #{movie.cost - @balance}" if @balance < movie.cost
    puts movie.show
    @balance -= movie.cost

  end

  def pay(payment)
    raise ArgumentError, "Ожидается положительное число, получено #{payment}" if payment <= 0
    @balance += payment
  end

  def film_costs(movie)
    raise NameError, "В базе нет такого фильма" unless movie
    self.filter(movie).first.cost
  end

end