module CashBox

    def cashbox_balance
      @cashbox_balance ||= Money.new(0, "UAH")
    end

    def put_to_cashbox(money)
      @cashbox_balance = cashbox_balance + money
    end

    def take(who)
      raise ArgumentError, "Нарушение безопасности, вызвана полиция" unless who == 'Bank'
      puts "Проведена инкассация"
      @cashbox_balance = Money.new(0, "UAH")
    end

end