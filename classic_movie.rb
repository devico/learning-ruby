class ClassicMovie < Movie

  def cost
    1.5
  end

  def show
    puts "#{@title} — классический фильм, режиссёр #{@author}"
    "Список фильмов режиссера #{@author}:"
  end



end