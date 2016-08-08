class Theatre < MovieCollection

  PERIOD_DAY = { morning: (8..12), afternoon: (13..16), evening: (17..23), night: (0..7) }
  FILTERS_MOVIE = { morning: {period: :ancient},
                    afternoon: {genre: 'Comedy', genre: 'Adventure'},
                    evening: {genre: 'Drama', genre: 'Mystery'} }

  def time_to_show(time)
    hour = DateTime.strptime(time, '%H').hour
    PERIOD_DAY.select{ |k,v| v.include?(hour) }.keys[0]
  end

  def show(params)
    order_time = time_to_show(params)
    raise ArgumentError, "В ночное время кинотеатр не работает" if order_time == :night
    order_movie = FILTERS_MOVIE.select{ |k,v| k == order_time }.values[0]
    movie = self.filter(order_movie).sample
  end

  def when?(params)
    FILTERS_MOVIE.find_all do |key,value|
      @time_of_day = key if self.filter(value).include?(self.filter(params).first)
    end
    @time_of_day
  end

end