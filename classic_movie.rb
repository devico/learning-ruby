class ClassicMovie < Movie

  def cost
    1.5
  end

  def show(num)
    "#{@title} — классический фильм, режиссёр #{@author}"", кроме этого еще #{num} фильмa(ов) #{@author} вошли в ТОП-250"
  end



end