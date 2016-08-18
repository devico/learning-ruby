require 'date'
require_relative 'cash_box'

class Netflix < MovieCollection

  attr_reader :balance

  def show(params)
    movie = self.filter(params).sort_by{ |m| m.rate.to_f*rand(1000)}.last
    raise NameError, "В базе нет такого фильма" unless movie
    raise ArgumentError, "Для просмотра #{movie.title} нужно еще пополнить баланс на #{movie.cost-@balance}" if @balance < movie.cost
    @balance -= movie.cost
    movie.show
  end

  def pay(payment)
    @@cashbox_netflix ||= 0.0
    raise ArgumentError, "Ожидается положительное число, получено #{payment}" if payment <= 0
    put_to_cashbox(payment)
    @@cashbox_netflix += payment
    @balance += payment
  end

  def film_costs(movie)
    movie = self.filter(movie).first
    raise NameError, "В базе нет такого фильма" unless movie
    movie.cost
  end

  def self.cash
    @@cashbox_netflix
  end

end