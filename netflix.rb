require 'date'

class Netflix < MovieCollection

  def balance
    @balance
  end

  def show(params)
    raise ArgumentError, "Не достаточно средств для просмотра" if self.balance < 0
    raise NameError, "В базе нет фильма \"#{params[:title]}\"" if self.filter(params).first.nil?
    movie = self.filter(params).first
    puts movie.show
    @balance = self.balance - movie.cost

  end

  def pay(payment)
    if payment <= 0
      raise ArgumentError, "Ожидается положительное число, получено #{payment}"
    else
      @balance = self.balance + payment.to_f
    end
  end

  def film_costs(movie)
    self.filter(movie).first.cost
  end

end