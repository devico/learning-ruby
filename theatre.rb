require 'date'

class Theatre < MovieCollection

  def time_of_day?(time)
   order_hour = time.split(':')[0]
   time_of_day = case order_hour.to_i
      when 8..12 then :morning
      when 13..16 then :afternoon
      when 17..23 then :evening
      else :night
    end
  end

  def show(params)

   order_time = self.time_of_day?(params)

   order_movie = case order_time
    when :morning then {period: :ancient}
    when :afternoon then {genre: 'Comedy', genre: 'Adventure'}
    when :evening then {genre: 'Drama', genre: 'Horrors'}
    else "В ночное время кинотеатр не работает"
    end

   movie = self.filter(order_movie).first

  end

end