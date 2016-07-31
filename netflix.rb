require 'date'

class Netflix < MovieCollection

  def show(params)
    self.filter(params).map{ |m| m.show }
  end

end