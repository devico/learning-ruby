require 'date'

class Netflix < MovieCollection

  def initialize

  end

  @t0 = Time.now

  def show(movie_name, t0)
    "Now showing: #{movie_name} #{t0.strftime("%H:%M")}"
  end

end