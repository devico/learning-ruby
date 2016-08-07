class AncientMovie < Movie

  def cost
    1.0
  end

  def period
    self.class.to_s.chomp("Movie").downcase.to_sym
  end

  def show
    "#{@title} — старый фильм (#{@year} год)"
  end

end