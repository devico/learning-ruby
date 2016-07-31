require 'date'

class AncientMovie < Movie
  @period = :ancient

  def period
    :ancient
  end

  def show
    "#{@title} — старый фильм (#{@year} год)"
  end

end