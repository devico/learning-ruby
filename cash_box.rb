module CashBox

  def cashbox_state
    puts "В кассе денег: #{@cashbox_balance}"
  end

  def put_to_cashbox(quantity)
    @cashbox_balance += quantity
  end

  def cashbox_inkass
    @cashbox_balance = 0.0
  end

  def take(who)
    if who == 'Bank'
      cashbox_inkass
      puts "Проведена инкассация"
    else
      raise ArgumentError, "Нарушение безопасности, вызвана полиция"
    end
  end

end