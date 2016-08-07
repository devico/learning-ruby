class ModernMovie < Movie

  def cost
    3.0
  end

  def period
    self.class.to_s.chomp("Movie").downcase.to_sym
  end

 def show
   "#{@title} — современное кино: играют #{@actors.join(", ")}"
 end

end