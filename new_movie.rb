class NewMovie < Movie

  def cost
    5.0
  end

  def show
    start_time = Time.now
    "#{@title} — новинка, вышло #{start_time.year - @year} лет назад!"
  end

end