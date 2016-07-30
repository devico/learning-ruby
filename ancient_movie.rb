require 'date'

class AncientMovie < Movie

   def show
      start_time = Time.now
      end_time = @length.to_i
      puts "#{@title} — старый фильм (#{@year} год)"
   end

end