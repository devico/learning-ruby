require 'date'

class Netflix < MovieCollection

  def initialize

  end

  def show(movie, t0, t1)
    "Now showing: #{movie.title} #{t0.strftime("%H:%M")} - #{t1.strftime("%H:%M")}"
  end

end