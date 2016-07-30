require 'date'

class ModernMovie < Movie

  def show
      start_time = Time.now
      end_time = @length.to_i
      puts "#{@title} — современное кино: играют #{@actors.join(", ")}"
   end

end