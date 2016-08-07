class ClassicMovie < Movie

  def cost
    1.5
  end

  def period
    self.class.to_s.chomp("Movie").downcase.to_sym
  end

  def show
    "#{@title} — классический фильм, режиссёр #{@author}"
  end

end