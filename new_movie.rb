class NewMovie < Movie

  def cost
    5.0
  end

  def period
    self.class.to_s.chomp("Movie").downcase.to_sym
  end

  def show
    start_time = Time.now
    "#{@title} — новинка, вышло #{start_time.year - @year} лет назад!"
  end

end