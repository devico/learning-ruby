class Theatre < MovieCollection

  include Enumerable

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
    movies = filters_to_hash(order_filter).map{ |fil_mov| self.filter(fil_mov) }.flatten
    movies.sort_by{ |m| m.rate.to_f*rand(1000)}.last
  end

  def when?(title)
    movie = self.filter(title).first
    period = FILTERS_MOVIE.find_all{ |per, fil| filters_to_hash(fil).detect{ |k| movie.matches_all?(k) } }.flatten[0]
    period
  end

  def filters_to_hash(hash_with_array)
    hash_with_array.map{ |k,v| v.kind_of?(Array) ? v.map{ |gen| Hash[k, gen] } : Hash[k,v] }.flatten
  end

end