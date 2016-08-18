module TopMovies

  class ModernMovie < Movie

    def cost
      3.0
    end

   def show
     "#{@title} — современное кино: играют #{@actors.join(", ")}"
   end

  end

end