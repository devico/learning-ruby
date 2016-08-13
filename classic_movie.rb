class ClassicMovie < Movie

  def cost
    1.5
  end

  def show
    puts "#{@title} — классический фильм, режиссёр #{@author}"
    puts "Список фильмов режиссера #{@author}:"
  end



end