require 'haml'

x = [1,2,3,4]
template = File.open('ttt.haml')
engine = Haml::Engine.new(template.read)
puts engine.render(x)