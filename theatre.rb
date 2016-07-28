class Theatre < MovieCollection

  def initialize

  end

  def show(movie, start_time, end_time)
    "Now showing: #{movie.title} #{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")}"
  end

end