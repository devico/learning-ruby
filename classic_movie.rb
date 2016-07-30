class ClassicMovie < Movie

def show
  start_time = Time.now
  end_time = @length.to_i
  puts "#{@title} — классический фильм, режиссёр #{@author}"
end

end