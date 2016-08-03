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
    @balance = payment.to_f
  end

  def how_much?(movie)
    self.filter(movie).first.cost
  end

end