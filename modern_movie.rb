require 'date'

class ModernMovie < Movie

  @period = :modern

  def show
      "#{@title} — современное кино: играют #{@actors.join(", ")}"
   end

end