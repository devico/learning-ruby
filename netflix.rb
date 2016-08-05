require 'date'

class Netflix < MovieCollection

  def balance
    @balance
  end

  def show(params)
    raise ArgumentError, "Не достаточно средств для просмотра" if @balance <= 0.0
    movie = self.filter(params).first
    raise NameError, "В базе нет такого фильма" if movie.nil?
    puts movie.show
    @balance -= movie.cost

  end

  def pay(payment)
    raise ArgumentError, "Ожидается положительное число, получено #{payment}" if payment <= 0
    @balance = @balance + payment.to_f
  end

  def film_costs(movie)
    self.filter(movie).first.cost
  end

end