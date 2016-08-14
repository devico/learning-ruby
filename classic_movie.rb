class ClassicMovie < Movie

  def cost
    1.5
  end

  def show
    "#{@title} — классический фильм, режиссёр #{@author}"", кроме этого еще #{@collection.filter(author: @author).length} фильмa(ов) #{@author} вошли в ТОП-250"
  end



end