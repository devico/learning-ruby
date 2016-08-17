module CashBox

  def cashbox_balance
    @cashbox_balance ||= 0.0
  end

  def put_to_cashbox(money)
    @cashbox_balance += money
  end

end