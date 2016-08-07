class AncientMovie < Movie

  def cost
    1.0
  end

  def period
    :ancient
  end

  def show
    "#{@title} — старый фильм (#{@year} год)"
  end

end