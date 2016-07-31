require 'date'

class NewMovie < Movie

  @period = :new

  def show
    start_time = Time.now
    "#{@title} — новинка, вышло #{start_time.year - @year} лет назад!"
  end

end