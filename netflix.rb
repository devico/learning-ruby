require 'date'

class Netflix < MovieCollection

  def balance
    @balance
  end

  def show(params)
    if self.balance >= 5.0
      movie = self.filter(params).first
      puts movie.show
      @balance = self.balance - movie.cost
    else
      raise ArgumentError, "Не достаточно средств для просмотра"
    end

  end

  def pay(payment)
    if payment > 0
      @balance = payment.to_f
    else
      raise ArgumentError, "Введена отрицательная сумма или ноль"
    end
  end

  def film_costs(movie)
    self.filter(movie).first.cost
  end

end