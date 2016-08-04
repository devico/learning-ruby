require 'date'

class Netflix < MovieCollection

  def balance
    @balance
  end

  def show(params)
    if self.balance < 5.0
      raise ArgumentError, "Не достаточно средств для просмотра"
    else
      movie = self.filter(params).first
      puts movie.show
      @balance = self.balance - movie.cost
    end

  end

  def pay(payment)
    if payment <= 0
      raise ArgumentError, "Введена отрицательная сумма или ноль"
    else
      @balance = payment.to_f
    end
  end

  def film_costs(movie)
    self.filter(movie).first.cost
  end

end