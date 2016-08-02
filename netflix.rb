require 'date'

class Netflix < MovieCollection
  attr_accessor :balance

  def show(params)
      movie = self.filter(params).first
      @balance = @balance - movie.cost
      if @balance > 0
        puts movie.show
      else
       raise ArgumentError, "Не достаточно средств для просмотра"
     end
  end

  def pay(payment)
    @balance = payment
  end

end