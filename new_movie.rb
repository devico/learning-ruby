require 'date'

class NewMovie < Movie

  def show
    start_time = Time.now
    end_time = @length.to_i
    puts "#{@title} — новинка, вышло #{time_now.year - @year} лет назад!"
  end

end