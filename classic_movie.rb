class ClassicMovie < Movie

  def period
    :classic
  end

  def show
    "#{@title} — классический фильм, режиссёр #{@author}"
  end

end