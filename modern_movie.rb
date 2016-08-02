class ModernMovie < Movie

  attr_accessor :cost

  def cost
    @cost = 3.0
  end

  def period
    :modern
  end

 def show
   "#{@title} — современное кино: играют #{@actors.join(", ")}"
 end

end