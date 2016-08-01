require 'date'

class Netflix < MovieCollection

  attr_accessor :balance

  @balance = 0.0

  def show(params)
    self.filter(params).map do |m|
      if (@balance - m.cost) >= 0
        @balance = @balance - m.cost
        @show_count += 1
        m.show
      end
    end
  end

  def pay(payment)
    @balance += payment
  end

end