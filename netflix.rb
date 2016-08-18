require 'date'

class Netflix < MovieCollection

  extend CashBox

  Money.use_i18n = false

  def self.cash
    cashbox_balance
  end

  attr_reader :balance

  def show(params)
    movie = self.filter(params).sort_by{ |m| m.rate.to_f*rand(1000)}.last
    raise NameError, "В базе нет такого фильма" unless movie
    diff = Money.new((movie.cost - @balance.to_f)*100, "UAH")
    raise ArgumentError, "Для просмотра #{movie.title} нужно еще пополнить баланс на #{diff }" if @balance.to_f < movie.cost
    @balance -= Money.new(movie.cost*100, "UAH")
    movie.show
  end

  def pay(payment)
    money = Money.new(payment*100, "UAH")
    raise ArgumentError, "Ожидается положительное число, получено #{money}" if payment <= 0
    put_to_cashbox(money)
    self.class.put_to_cashbox(money)
    @balance += money
  end

  def film_costs(title)
    movie = self.filter(title).first
    raise NameError, "В базе нет такого фильма" unless movie
    Money.new(movie.cost*100, "UAH")
  end



end