class ClassicMovie < Movie

  def cost
    1.5
  end

  def show
    "#{@title} — классический фильм, режиссёр #{@author}"
  end

end