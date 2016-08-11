class Theatre < MovieCollection

  PERIOD_DAY = { morning: (8..12), afternoon: (13..16), evening: (17..23), night: (0..7) }
  FILTERS_MOVIE = { morning: { period: :ancient },
                    afternoon: { genre: ['Comedy', 'Adventure']},
                    evening: { genre: ['Drama', 'Mystery'] } }

  def time_to_show(time)
    hour = DateTime.strptime(time, '%H').hour
    PERIOD_DAY.select{ |k,v| v.include?(hour) }.keys[0]
  end

  def show(params)
    order_time = time_to_show(params)
    raise ArgumentError, "В ночное время кинотеатр не работает" if order_time == :night
    order_filter = FILTERS_MOVIE.select{ |k,v| k == order_time }.values[0]
    movie = filters_to_hash(order_filter).map{ |fil_mov| self.filter(fil_mov) }.first[0]
    movie
  end

  def when?(title)
    movie = self.filter(title).first
    period = FILTERS_MOVIE.find_all{ |per, fil| filters_to_hash(fil).detect{ |k| movie.matches_all?(k) } }.flatten[0]
    period
  end

  def filters_to_hash(hash_with_array)
    fs = []
    hash_with_array.select do |k,v|
       v.map{ |gen| fs << Hash[k, gen] } if v.kind_of?(Array)
       fs << Hash[k,v] unless v.kind_of?(Array)
     end
    fs
  end

end