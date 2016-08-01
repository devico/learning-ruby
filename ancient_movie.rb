class AncientMovie < Movie

  def cost
    1.5
  end

  def period
    :classic
  end

  def show
    "#{@title} — старый фильм (#{@year} год)"
  end

end